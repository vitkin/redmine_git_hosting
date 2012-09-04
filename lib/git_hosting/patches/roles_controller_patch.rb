require_dependency 'principal'
require_dependency 'user'
require_dependency 'git_hosting'
require_dependency 'roles_controller'

module GitHosting
    module Patches
	module RolesControllerPatch
	    # Pre-1.4 (Not RESTfull)
	    def new_with_disable_update
		# Turn of updates during repository update
		GitHostingObserver.set_update_active(false);

		# Do actual update
		new_without_disable_update

		# Reenable updates to perform a single update
		GitHostingObserver.set_update_active(true);
	    end

	    # Post-1.4 (RESTfull)
	    def create_with_disable_update
		# Turn of updates during repository update
		GitHostingObserver.set_update_active(false);

		# Do actual update
		create_without_disable_update

		# Reenable updates to perform a single update
		GitHostingObserver.set_update_active(true);
	    end

	    # Pre-1.4 (Not RESTfull)
	    def edit_with_disable_update
		# Turn of updates during repository update
		GitHostingObserver.set_update_active(false);

		# Do actual update
		edit_without_disable_update

		# Reenable updates to perform a single update
		GitHostingObserver.set_update_active(true);
	    end

	    # Post-1.4 (RESTfull)
	    def update_with_disable_update
		# Turn of updates during repository update
		GitHostingObserver.set_update_active(false);

		# Do actual update
		update_without_disable_update

		# Reenable updates to perform a single update
		GitHostingObserver.set_update_active(true);
	    end

	    def destroy_with_disable_update
		# Turn of updates during repository update
		GitHostingObserver.set_update_active(false);

		# Do actual update
		destroy_without_disable_update

		# Reenable updates to perform a single update
		GitHostingObserver.set_update_active(true);
	    end
	    def self.included(base)
		base.class_eval do
		    unloadable
		end
		begin
		    # RESTfull (post-1.4)
		    base.send(:alias_method_chain, :create, :disable_update)
		rescue
		    # Not RESTfull (pre-1.4)
		    base.send(:alias_method_chain, :new, :disable_update) rescue nil
		end
		begin
		    # RESTfull (post-1.4)
		    base.send(:alias_method_chain, :update, :disable_update)
		rescue
		    # Not RESTfull (pre-1.4)
		    base.send(:alias_method_chain, :edit, :disable_update) rescue nil
		end

		base.send(:alias_method_chain, :destroy, :disable_update) rescue nil
	    end
	end
    end
end

# Patch in changes
RolesController.send(:include, GitHosting::Patches::RolesControllerPatch)
