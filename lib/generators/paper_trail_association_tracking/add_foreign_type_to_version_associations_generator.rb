# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module PaperTrailAssociationTracking
  # Installs PaperTrail in a rails app.
  class AddForeignTypeToVersionAssociationsGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    # Class names of MySQL adapters.
    # - `MysqlAdapter` - Used by gems: `mysql`, `activerecord-jdbcmysql-adapter`.
    # - `Mysql2Adapter` - Used by `mysql2` gem.
    MYSQL_ADAPTERS = [
      "ActiveRecord::ConnectionAdapters::MysqlAdapter",
      "ActiveRecord::ConnectionAdapters::Mysql2Adapter"
    ].freeze

    source_root File.expand_path("../templates", __FILE__)

    desc "Generates (but does not run) a migration to add a the foreign_type column to the version_associations table after upgrading from v1.0 or earlier."

    def create_migrations
      add_paper_trail_migration("add_foreign_type_to_version_associations")
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_paper_trail_migration(template)
      migration_dir = File.expand_path("db/migrate")
      if self.class.migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
      else
        migration_template(
          "#{template}.rb.erb",
          "db/migrate/#{template}.rb",
          migration_version: migration_version
        )
      end
    end

    private

    def migration_version
      "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
    end
  end
end
