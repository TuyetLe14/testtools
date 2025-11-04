CREATE TABLE [users] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [name] varchar(100) NOT NULL,
  [email] varchar(120) UNIQUE NOT NULL,
  [password_hash] varchar(255) NOT NULL,
  [is_active] boolean DEFAULT (true),
  [is_deleted] boolean DEFAULT (false),
  [created_at] timestamp NOT NULL DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now()),
  [deleted_at] timestamp
)
GO

CREATE TABLE [roles] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] varchar(50) UNIQUE NOT NULL,
  [description] varchar(255),
  [is_system] boolean DEFAULT (false),
  [created_at] timestamp NOT NULL DEFAULT (now())
)
GO

CREATE TABLE [permissions] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] varchar(100) UNIQUE NOT NULL,
  [resource] varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  [description] text
)
GO

CREATE TABLE [role_permissions] (
  [role_id] int NOT NULL,
  [permission_id] int NOT NULL,
  [granted_at] timestamp DEFAULT (now()),
  PRIMARY KEY ([role_id], [permission_id])
)
GO

CREATE TABLE [user_roles] (
  [user_id] bigint NOT NULL,
  [role_id] int NOT NULL,
  [assigned_at] timestamp DEFAULT (now()),
  [assigned_by] bigint,
  PRIMARY KEY ([user_id], [role_id])
)
GO

CREATE TABLE [api_tokens] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [user_id] bigint NOT NULL,
  [token_hash] varchar(255) UNIQUE NOT NULL,
  [name] varchar(100) NOT NULL,
  [scopes] text,
  [expires_at] timestamp,
  [last_used_at] timestamp,
  [is_active] boolean DEFAULT (true),
  [created_at] timestamp NOT NULL DEFAULT (now())
)
GO

CREATE TABLE [login_history] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [user_id] bigint NOT NULL,
  [ip_address] varchar(45),
  [user_agent] text,
  [login_at] timestamp NOT NULL DEFAULT (now()),
  [success] boolean NOT NULL,
  [failure_reason] varchar(255)
)
GO

CREATE TABLE [projects] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [name] varchar(150) NOT NULL,
  [description] text,
  [owner_id] bigint NOT NULL,
  [status] enum(active,archived,on_hold) NOT NULL DEFAULT 'active',
  [is_deleted] boolean DEFAULT (false),
  [created_at] timestamp NOT NULL DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now()),
  [deleted_at] timestamp
)
GO

CREATE TABLE [project_members] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [project_id] bigint NOT NULL,
  [user_id] bigint NOT NULL,
  [role] varchar(50) NOT NULL DEFAULT 'member',
  [joined_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [requirements] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [project_id] bigint NOT NULL,
  [code] varchar(50) NOT NULL,
  [title] varchar(255) NOT NULL,
  [description] text,
  [type] enum(functional,non_functional,security,performance) NOT NULL,
  [priority] enum(low,medium,high,critical) DEFAULT 'medium',
  [status] enum(draft,approved,implemented,deprecated) DEFAULT 'draft',
  [created_by] bigint NOT NULL,
  [created_at] timestamp NOT NULL DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [test_suites] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [project_id] bigint NOT NULL,
  [name] varchar(150) NOT NULL,
  [description] text,
  [parent_id] bigint,
  [order_index] int DEFAULT (0),
  [is_deleted] boolean DEFAULT (false),
  [created_by] bigint NOT NULL,
  [created_at] timestamp NOT NULL DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [test_cases] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [project_id] bigint NOT NULL,
  [title] varchar(255) NOT NULL,
  [description] text,
  [type] enum(manual,automation,performance) NOT NULL,
  [priority] enum(low,medium,high,critical) NOT NULL DEFAULT 'medium',
  [status] enum(draft,active,deprecated) NOT NULL DEFAULT 'draft',
  [preconditions] text,
  [postconditions] text,
  [version] int NOT NULL DEFAULT (1),
  [version_group_id] bigint,
  [parent_id] bigint,
  [is_latest] boolean DEFAULT (true),
  [estimated_duration] int,
  [is_deleted] boolean DEFAULT (false),
  [created_by] bigint NOT NULL,
  [created_at] timestamp NOT NULL DEFAULT (now()),
  [updated_by] bigint,
  [updated_at] timestamp DEFAULT (now()),
  [deleted_at] timestamp
)
GO

CREATE TABLE [suite_test_cases] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [suite_id] bigint NOT NULL,
  [test_case_id] bigint NOT NULL,
  [order_index] int DEFAULT (0)
)
GO

CREATE TABLE [test_steps] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [test_case_id] bigint NOT NULL,
  [step_no] int NOT NULL,
  [action] text NOT NULL,
  [expected_result] text NOT NULL,
  [test_data] text
)
GO

CREATE TABLE [tags] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [name] varchar(50) UNIQUE NOT NULL,
  [color] varchar(7),
  [created_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [test_case_tags] (
  [test_case_id] bigint NOT NULL,
  [tag_id] int NOT NULL,
  PRIMARY KEY ([test_case_id], [tag_id])
)
GO

CREATE TABLE [requirement_test_cases] (
  [requirement_id] bigint NOT NULL,
  [test_case_id] bigint NOT NULL,
  [created_at] timestamp DEFAULT (now()),
  PRIMARY KEY ([requirement_id], [test_case_id])
)
GO

CREATE TABLE [test_data_sets] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [test_case_id] bigint NOT NULL,
  [name] varchar(100) NOT NULL,
  [data_json] json NOT NULL,
  [is_default] boolean DEFAULT (false),
  [created_at] timestamp DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [automation_tests] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [test_case_id] bigint UNIQUE NOT NULL,
  [framework] enum(pytest,selenium,robot,cypress,playwright,testng) NOT NULL,
  [repo_url] varchar(255),
  [branch] varchar(100) DEFAULT 'main',
  [script_path] varchar(255) NOT NULL,
  [test_command] text,
  [timeout] int DEFAULT (300),
  [last_run_at] timestamp,
  [last_run_status] enum(passed,failed,error),
  [created_at] timestamp DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [performance_tests] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [test_case_id] bigint UNIQUE NOT NULL,
  [tool] enum(jmeter,locust,k6,gatling,artillery) NOT NULL,
  [file_path] varchar(255) NOT NULL,
  [target_url] varchar(255) NOT NULL,
  [virtual_users] int NOT NULL DEFAULT (1),
  [ramp_up_time] int DEFAULT (0),
  [duration] int NOT NULL,
  [think_time] int DEFAULT (0),
  [success_rate_threshold] decimal(5,2) DEFAULT (95),
  [avg_response_threshold] int DEFAULT (1000),
  [created_at] timestamp DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [test_campaigns] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [project_id] bigint NOT NULL,
  [name] varchar(150) NOT NULL,
  [description] text,
  [environment] varchar(100) NOT NULL,
  [scheduled_at] timestamp,
  [started_at] timestamp,
  [completed_at] timestamp,
  [status] enum(pending,running,completed,cancelled) NOT NULL DEFAULT 'pending',
  [created_by] bigint NOT NULL,
  [created_at] timestamp NOT NULL DEFAULT (now())
)
GO

CREATE TABLE [test_runs] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [test_case_id] bigint NOT NULL,
  [campaign_id] bigint,
  [executed_by] bigint NOT NULL,
  [start_time] timestamp NOT NULL DEFAULT (now()),
  [end_time] timestamp,
  [status] enum(passed,failed,error,pending,running,skipped,blocked) NOT NULL DEFAULT 'pending',
  [environment] varchar(100) NOT NULL,
  [build_version] varchar(50),
  [browser] varchar(50),
  [os] varchar(50),
  [notes] text,
  [execution_time] int,
  [created_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [test_run_steps] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [test_run_id] bigint NOT NULL,
  [test_step_id] bigint,
  [step_no] int NOT NULL,
  [actual_result] text,
  [status] enum(passed,failed,skipped) NOT NULL,
  [screenshot_path] varchar(255),
  [executed_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [test_run_attachments] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [test_run_id] bigint NOT NULL,
  [file_name] varchar(255) NOT NULL,
  [file_path] varchar(500) NOT NULL,
  [file_type] varchar(50),
  [file_size] bigint,
  [uploaded_by] bigint NOT NULL,
  [uploaded_at] timestamp NOT NULL DEFAULT (now())
)
GO

CREATE TABLE [defects] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [project_id] bigint NOT NULL,
  [test_run_id] bigint,
  [title] varchar(255) NOT NULL,
  [description] text NOT NULL,
  [severity] enum(low,medium,high,critical) NOT NULL DEFAULT 'medium',
  [priority] enum(low,medium,high,critical) NOT NULL DEFAULT 'medium',
  [status] enum(open,in_progress,resolved,closed,reopened) NOT NULL DEFAULT 'open',
  [assignee_id] bigint,
  [reporter_id] bigint NOT NULL,
  [environment] varchar(100),
  [steps_to_reproduce] text,
  [expected_behavior] text,
  [actual_behavior] text,
  [resolved_at] timestamp,
  [closed_at] timestamp,
  [created_at] timestamp NOT NULL DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [defect_attachments] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [defect_id] bigint NOT NULL,
  [file_name] varchar(255) NOT NULL,
  [file_path] varchar(500) NOT NULL,
  [file_type] varchar(50),
  [file_size] bigint,
  [uploaded_by] bigint NOT NULL,
  [uploaded_at] timestamp NOT NULL DEFAULT (now())
)
GO

CREATE TABLE [comments] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [entity_type] varchar(50) NOT NULL,
  [entity_id] bigint NOT NULL,
  [user_id] bigint NOT NULL,
  [parent_id] bigint,
  [content] text NOT NULL,
  [is_deleted] boolean DEFAULT (false),
  [created_at] timestamp NOT NULL DEFAULT (now()),
  [updated_at] timestamp DEFAULT (now())
)
GO

CREATE TABLE [audit_logs] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [table_name] varchar(50) NOT NULL,
  [record_id] bigint NOT NULL,
  [action] enum(INSERT,UPDATE,DELETE) NOT NULL,
  [old_values] json,
  [new_values] json,
  [changed_by] bigint NOT NULL,
  [changed_at] timestamp NOT NULL DEFAULT (now()),
  [ip_address] varchar(45),
  [user_agent] text
)
GO

CREATE TABLE [notifications] (
  [id] bigint PRIMARY KEY IDENTITY(1, 1),
  [user_id] bigint NOT NULL,
  [type] varchar(50) NOT NULL,
  [title] varchar(255) NOT NULL,
  [message] text NOT NULL,
  [related_entity] varchar(50),
  [related_id] bigint,
  [is_read] boolean DEFAULT (false),
  [read_at] timestamp,
  [created_at] timestamp NOT NULL DEFAULT (now())
)
GO

CREATE TABLE [system_configs] (
  [id] int PRIMARY KEY IDENTITY(1, 1),
  [config_key] varchar(100) UNIQUE NOT NULL,
  [config_value] text NOT NULL,
  [description] text,
  [is_encrypted] boolean DEFAULT (false),
  [updated_by] bigint,
  [updated_at] timestamp DEFAULT (now())
)
GO

CREATE INDEX [idx_users_email] ON [users] ("email")
GO

CREATE INDEX [idx_users_active] ON [users] ("is_active")
GO

CREATE INDEX [idx_users_created] ON [users] ("created_at")
GO

CREATE INDEX [idx_roles_name] ON [roles] ("name")
GO

CREATE INDEX [idx_permissions_resource_action] ON [permissions] ("resource", "action")
GO

CREATE INDEX [idx_role_perms_permission] ON [role_permissions] ("permission_id")
GO

CREATE INDEX [idx_user_roles_role] ON [user_roles] ("role_id")
GO

CREATE INDEX [idx_api_tokens_user] ON [api_tokens] ("user_id")
GO

CREATE UNIQUE INDEX [uk_api_tokens_hash] ON [api_tokens] ("token_hash")
GO

CREATE INDEX [idx_api_tokens_expires] ON [api_tokens] ("expires_at")
GO

CREATE INDEX [idx_login_history_user] ON [login_history] ("user_id")
GO

CREATE INDEX [idx_login_history_time] ON [login_history] ("login_at")
GO

CREATE INDEX [idx_login_history_user_time] ON [login_history] ("user_id", "login_at")
GO

CREATE INDEX [idx_projects_owner] ON [projects] ("owner_id")
GO

CREATE INDEX [idx_projects_status] ON [projects] ("status")
GO

CREATE INDEX [idx_projects_status_deleted] ON [projects] ("status", "is_deleted")
GO

CREATE INDEX [idx_projects_created] ON [projects] ("created_at")
GO

CREATE UNIQUE INDEX [uk_project_members] ON [project_members] ("project_id", "user_id")
GO

CREATE INDEX [idx_project_members_user] ON [project_members] ("user_id")
GO

CREATE INDEX [idx_requirements_project] ON [requirements] ("project_id")
GO

CREATE UNIQUE INDEX [uk_requirements_project_code] ON [requirements] ("project_id", "code")
GO

CREATE INDEX [idx_requirements_status] ON [requirements] ("status")
GO

CREATE INDEX [idx_suites_project] ON [test_suites] ("project_id")
GO

CREATE INDEX [idx_suites_parent] ON [test_suites] ("parent_id")
GO

CREATE INDEX [idx_suites_project_order] ON [test_suites] ("project_id", "order_index")
GO

CREATE INDEX [idx_testcases_project] ON [test_cases] ("project_id")
GO

CREATE INDEX [idx_testcases_creator] ON [test_cases] ("created_by")
GO

CREATE INDEX [idx_testcases_type] ON [test_cases] ("type")
GO

CREATE INDEX [idx_testcases_priority] ON [test_cases] ("priority")
GO

CREATE INDEX [idx_testcases_status] ON [test_cases] ("status")
GO

CREATE INDEX [idx_testcases_parent] ON [test_cases] ("parent_id")
GO

CREATE INDEX [idx_testcases_version_group] ON [test_cases] ("version_group_id")
GO

CREATE INDEX [idx_testcases_project_type] ON [test_cases] ("project_id", "type")
GO

CREATE INDEX [idx_testcases_project_status] ON [test_cases] ("project_id", "status")
GO

CREATE INDEX [idx_testcases_version_latest] ON [test_cases] ("version_group_id", "is_latest")
GO

CREATE INDEX [idx_testcases_created] ON [test_cases] ("created_at")
GO

CREATE UNIQUE INDEX [uk_suite_testcases] ON [suite_test_cases] ("suite_id", "test_case_id")
GO

CREATE INDEX [idx_suite_testcases_testcase] ON [suite_test_cases] ("test_case_id")
GO

CREATE INDEX [idx_suite_testcases_order] ON [suite_test_cases] ("suite_id", "order_index")
GO

CREATE INDEX [idx_steps_testcase] ON [test_steps] ("test_case_id")
GO

CREATE UNIQUE INDEX [uk_steps_testcase_stepno] ON [test_steps] ("test_case_id", "step_no")
GO

CREATE UNIQUE INDEX [uk_tags_name] ON [tags] ("name")
GO

CREATE INDEX [idx_testcase_tags_tag] ON [test_case_tags] ("tag_id")
GO

CREATE INDEX [idx_req_testcases_testcase] ON [requirement_test_cases] ("test_case_id")
GO

CREATE INDEX [idx_test_data_testcase] ON [test_data_sets] ("test_case_id")
GO

CREATE INDEX [idx_test_data_default] ON [test_data_sets] ("test_case_id", "is_default")
GO

CREATE UNIQUE INDEX [uk_automation_testcase] ON [automation_tests] ("test_case_id")
GO

CREATE INDEX [idx_automation_framework] ON [automation_tests] ("framework")
GO

CREATE INDEX [idx_automation_last_status] ON [automation_tests] ("last_run_status")
GO

CREATE UNIQUE INDEX [uk_performance_testcase] ON [performance_tests] ("test_case_id")
GO

CREATE INDEX [idx_performance_tool] ON [performance_tests] ("tool")
GO

CREATE INDEX [idx_campaigns_project] ON [test_campaigns] ("project_id")
GO

CREATE INDEX [idx_campaigns_status] ON [test_campaigns] ("status")
GO

CREATE INDEX [idx_campaigns_scheduled] ON [test_campaigns] ("scheduled_at")
GO

CREATE INDEX [idx_campaigns_project_status] ON [test_campaigns] ("project_id", "status")
GO

CREATE INDEX [idx_testruns_testcase] ON [test_runs] ("test_case_id")
GO

CREATE INDEX [idx_testruns_campaign] ON [test_runs] ("campaign_id")
GO

CREATE INDEX [idx_testruns_executor] ON [test_runs] ("executed_by")
GO

CREATE INDEX [idx_testruns_status] ON [test_runs] ("status")
GO

CREATE INDEX [idx_testruns_start_time] ON [test_runs] ("start_time")
GO

CREATE INDEX [idx_testruns_testcase_time] ON [test_runs] ("test_case_id", "start_time")
GO

CREATE INDEX [idx_testruns_status_time] ON [test_runs] ("status", "start_time")
GO

CREATE INDEX [idx_testruns_campaign_status] ON [test_runs] ("campaign_id", "status")
GO

CREATE INDEX [idx_testruns_created] ON [test_runs] ("created_at")
GO

CREATE INDEX [idx_testrun_steps_testrun] ON [test_run_steps] ("test_run_id")
GO

CREATE INDEX [idx_testrun_steps_teststep] ON [test_run_steps] ("test_step_id")
GO

CREATE INDEX [idx_testrun_steps_testrun_stepno] ON [test_run_steps] ("test_run_id", "step_no")
GO

CREATE INDEX [idx_attachments_testrun] ON [test_run_attachments] ("test_run_id")
GO

CREATE INDEX [idx_attachments_type] ON [test_run_attachments] ("file_type")
GO

CREATE INDEX [idx_attachments_uploaded] ON [test_run_attachments] ("uploaded_at")
GO

CREATE INDEX [idx_defects_project] ON [defects] ("project_id")
GO

CREATE INDEX [idx_defects_testrun] ON [defects] ("test_run_id")
GO

CREATE INDEX [idx_defects_status] ON [defects] ("status")
GO

CREATE INDEX [idx_defects_severity] ON [defects] ("severity")
GO

CREATE INDEX [idx_defects_assignee] ON [defects] ("assignee_id")
GO

CREATE INDEX [idx_defects_reporter] ON [defects] ("reporter_id")
GO

CREATE INDEX [idx_defects_project_status] ON [defects] ("project_id", "status")
GO

CREATE INDEX [idx_defects_project_status_severity] ON [defects] ("project_id", "status", "severity")
GO

CREATE INDEX [idx_defects_created] ON [defects] ("created_at")
GO

CREATE INDEX [idx_defect_attachments_defect] ON [defect_attachments] ("defect_id")
GO

CREATE INDEX [idx_comments_entity] ON [comments] ("entity_type", "entity_id")
GO

CREATE INDEX [idx_comments_user] ON [comments] ("user_id")
GO

CREATE INDEX [idx_comments_parent] ON [comments] ("parent_id")
GO

CREATE INDEX [idx_comments_created] ON [comments] ("created_at")
GO

CREATE INDEX [idx_audit_table_record] ON [audit_logs] ("table_name", "record_id")
GO

CREATE INDEX [idx_audit_user] ON [audit_logs] ("changed_by")
GO

CREATE INDEX [idx_audit_time] ON [audit_logs] ("changed_at")
GO

CREATE INDEX [idx_audit_action] ON [audit_logs] ("action")
GO

CREATE INDEX [idx_audit_table_record_time] ON [audit_logs] ("table_name", "record_id", "changed_at")
GO

CREATE INDEX [idx_notifications_user] ON [notifications] ("user_id")
GO

CREATE INDEX [idx_notifications_read] ON [notifications] ("is_read")
GO

CREATE INDEX [idx_notifications_user_read] ON [notifications] ("user_id", "is_read")
GO

CREATE INDEX [idx_notifications_user_created] ON [notifications] ("user_id", "created_at")
GO

CREATE INDEX [idx_notifications_created] ON [notifications] ("created_at")
GO

CREATE UNIQUE INDEX [uk_configs_key] ON [system_configs] ("config_key")
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g. admin, tester, manager, viewer',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'roles',
@level2type = N'Column', @level2name = 'name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'System roles cannot be deleted',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'roles',
@level2type = N'Column', @level2name = 'is_system';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g. create_project, delete_testcase, view_reports',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'permissions',
@level2type = N'Column', @level2name = 'name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'project, testcase, testrun, report',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'permissions',
@level2type = N'Column', @level2name = 'resource';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'create, read, update, delete, execute',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'permissions',
@level2type = N'Column', @level2name = 'action';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for both FKs',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'role_permissions';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for main FKs',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'user_roles';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for user_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'api_tokens';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'JSON array of scopes',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'api_tokens',
@level2type = N'Column', @level2name = 'scopes';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Partition by RANGE(login_at) - monthly. ON DELETE CASCADE',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'login_history';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE RESTRICT for owner_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'projects';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for both FKs',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'project_members';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'lead, member, viewer',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'project_members',
@level2type = N'Column', @level2name = 'role';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for project_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'requirements';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g. REQ-001',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'requirements',
@level2type = N'Column', @level2name = 'code';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for project_id. Add CHECK to prevent circular reference',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_suites';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Support nested suites',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_suites',
@level2type = N'Column', @level2name = 'parent_id';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for project_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_cases';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Groups versions of same testcase',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_cases',
@level2type = N'Column', @level2name = 'version_group_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Reference to previous version',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_cases',
@level2type = N'Column', @level2name = 'parent_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Flag for latest version',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_cases',
@level2type = N'Column', @level2name = 'is_latest';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Estimated time in minutes',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_cases',
@level2type = N'Column', @level2name = 'estimated_duration';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for both FKs',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'suite_test_cases';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for test_case_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_steps';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'JSON or plain text',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_steps',
@level2type = N'Column', @level2name = 'test_data';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Hex color code',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'tags',
@level2type = N'Column', @level2name = 'color';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for both FKs',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_case_tags';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for both FKs',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'requirement_test_cases';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for test_case_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_data_sets';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Test data as JSON object',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_data_sets',
@level2type = N'Column', @level2name = 'data_json';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for test_case_id. Add CHECK constraint: test_case.type must be automation',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'automation_tests';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Git repository URL',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'automation_tests',
@level2type = N'Column', @level2name = 'repo_url';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Test script file path',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'automation_tests',
@level2type = N'Column', @level2name = 'script_path';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Command to run test',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'automation_tests',
@level2type = N'Column', @level2name = 'test_command';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Timeout in seconds',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'automation_tests',
@level2type = N'Column', @level2name = 'timeout';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for test_case_id. Add CHECK: test_case.type must be performance',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'performance_tests';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Number of virtual users',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'performance_tests',
@level2type = N'Column', @level2name = 'virtual_users';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Ramp up time in seconds',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'performance_tests',
@level2type = N'Column', @level2name = 'ramp_up_time';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Test duration in seconds',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'performance_tests',
@level2type = N'Column', @level2name = 'duration';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Think time between requests in seconds',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'performance_tests',
@level2type = N'Column', @level2name = 'think_time';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Success rate threshold percentage',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'performance_tests',
@level2type = N'Column', @level2name = 'success_rate_threshold';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Average response time threshold in ms',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'performance_tests',
@level2type = N'Column', @level2name = 'avg_response_threshold';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for project_id. Add CHECK: started_at >= scheduled_at',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_campaigns';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'dev, staging, production',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_campaigns',
@level2type = N'Column', @level2name = 'environment';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Partition by RANGE(start_time) - monthly. ON DELETE CASCADE for test_case_id. Add CHECK: end_time >= start_time',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_runs';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Version of app being tested',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_runs',
@level2type = N'Column', @level2name = 'build_version';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Chrome, Firefox, Safari, etc',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_runs',
@level2type = N'Column', @level2name = 'browser';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Windows, Linux, MacOS, etc',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_runs',
@level2type = N'Column', @level2name = 'os';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Execution time in seconds',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_runs',
@level2type = N'Column', @level2name = 'execution_time';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for test_run_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_run_steps';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Link to original test step',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_run_steps',
@level2type = N'Column', @level2name = 'test_step_id';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for test_run_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_run_attachments';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'image, video, log, report',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_run_attachments',
@level2type = N'Column', @level2name = 'file_type';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'File size in bytes',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'test_run_attachments',
@level2type = N'Column', @level2name = 'file_size';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for project_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'defects';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for defect_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'defect_attachments';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for user_id',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'comments';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'test_case, test_run, defect, requirement',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'comments',
@level2type = N'Column', @level2name = 'entity_type';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'For threaded comments',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'comments',
@level2type = N'Column', @level2name = 'parent_id';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Partition by RANGE(changed_at) - monthly. ON DELETE SET NULL for changed_by',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'audit_logs';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'IPv4 or IPv6',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'audit_logs',
@level2type = N'Column', @level2name = 'ip_address';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'ON DELETE CASCADE for user_id. Consider archiving old notifications after 90 days',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'notifications';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'test_run_completed, defect_assigned, etc',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'notifications',
@level2type = N'Column', @level2name = 'type';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'test_run, defect, project',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'notifications',
@level2type = N'Column', @level2name = 'related_entity';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'ID of related entity',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'notifications',
@level2type = N'Column', @level2name = 'related_id';
GO

ALTER TABLE [role_permissions] ADD FOREIGN KEY ([role_id]) REFERENCES [roles] ([id])
GO

ALTER TABLE [role_permissions] ADD FOREIGN KEY ([permission_id]) REFERENCES [permissions] ([id])
GO

ALTER TABLE [user_roles] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [user_roles] ADD FOREIGN KEY ([role_id]) REFERENCES [roles] ([id])
GO

ALTER TABLE [user_roles] ADD FOREIGN KEY ([assigned_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [api_tokens] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [login_history] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [projects] ADD FOREIGN KEY ([owner_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [project_members] ADD FOREIGN KEY ([project_id]) REFERENCES [projects] ([id])
GO

ALTER TABLE [project_members] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [requirements] ADD FOREIGN KEY ([project_id]) REFERENCES [projects] ([id])
GO

ALTER TABLE [requirements] ADD FOREIGN KEY ([created_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [test_suites] ADD FOREIGN KEY ([project_id]) REFERENCES [projects] ([id])
GO

ALTER TABLE [test_suites] ADD FOREIGN KEY ([parent_id]) REFERENCES [test_suites] ([id])
GO

ALTER TABLE [test_suites] ADD FOREIGN KEY ([created_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [test_cases] ADD FOREIGN KEY ([project_id]) REFERENCES [projects] ([id])
GO

ALTER TABLE [test_cases] ADD FOREIGN KEY ([parent_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [test_cases] ADD FOREIGN KEY ([created_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [test_cases] ADD FOREIGN KEY ([updated_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [suite_test_cases] ADD FOREIGN KEY ([suite_id]) REFERENCES [test_suites] ([id])
GO

ALTER TABLE [suite_test_cases] ADD FOREIGN KEY ([test_case_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [test_steps] ADD FOREIGN KEY ([test_case_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [test_case_tags] ADD FOREIGN KEY ([test_case_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [test_case_tags] ADD FOREIGN KEY ([tag_id]) REFERENCES [tags] ([id])
GO

ALTER TABLE [requirement_test_cases] ADD FOREIGN KEY ([requirement_id]) REFERENCES [requirements] ([id])
GO

ALTER TABLE [requirement_test_cases] ADD FOREIGN KEY ([test_case_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [test_data_sets] ADD FOREIGN KEY ([test_case_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [automation_tests] ADD FOREIGN KEY ([test_case_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [performance_tests] ADD FOREIGN KEY ([test_case_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [test_campaigns] ADD FOREIGN KEY ([project_id]) REFERENCES [projects] ([id])
GO

ALTER TABLE [test_campaigns] ADD FOREIGN KEY ([created_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [test_runs] ADD FOREIGN KEY ([test_case_id]) REFERENCES [test_cases] ([id])
GO

ALTER TABLE [test_runs] ADD FOREIGN KEY ([campaign_id]) REFERENCES [test_campaigns] ([id])
GO

ALTER TABLE [test_runs] ADD FOREIGN KEY ([executed_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [test_run_steps] ADD FOREIGN KEY ([test_run_id]) REFERENCES [test_runs] ([id])
GO

ALTER TABLE [test_run_steps] ADD FOREIGN KEY ([test_step_id]) REFERENCES [test_steps] ([id])
GO

ALTER TABLE [test_run_attachments] ADD FOREIGN KEY ([test_run_id]) REFERENCES [test_runs] ([id])
GO

ALTER TABLE [test_run_attachments] ADD FOREIGN KEY ([uploaded_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [defects] ADD FOREIGN KEY ([project_id]) REFERENCES [projects] ([id])
GO

ALTER TABLE [defects] ADD FOREIGN KEY ([test_run_id]) REFERENCES [test_runs] ([id])
GO

ALTER TABLE [defects] ADD FOREIGN KEY ([assignee_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [defects] ADD FOREIGN KEY ([reporter_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [defect_attachments] ADD FOREIGN KEY ([defect_id]) REFERENCES [defects] ([id])
GO

ALTER TABLE [defect_attachments] ADD FOREIGN KEY ([uploaded_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [comments] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [comments] ADD FOREIGN KEY ([parent_id]) REFERENCES [comments] ([id])
GO

ALTER TABLE [audit_logs] ADD FOREIGN KEY ([changed_by]) REFERENCES [users] ([id])
GO

ALTER TABLE [notifications] ADD FOREIGN KEY ([user_id]) REFERENCES [users] ([id])
GO

ALTER TABLE [system_configs] ADD FOREIGN KEY ([updated_by]) REFERENCES [users] ([id])
GO
