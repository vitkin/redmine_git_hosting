require_dependency 'principal'
require_dependency 'user'
require_dependency 'git_hosting'
require_dependency 'members_controller'

module GitHosting
    module Patches
	module MembersControllerPatch
	    # pre-1.4 (Non RESTfull)
	    def new_with_disable_update
		# Turn of updates during repository update
		GitHostingObserver.set_update_active(false);

		# Do actual update
		new_without_disable_update

		# Reenable updates to perform a single update
		GitHostingObserver.set_update_active(true);
	    end
	    # post-1.4 (RESTfull)
	    def create_with_disable_update
		# Turn of updates during repository update
		GitHostingObserver.set_update_active(false);

		# Do actual update
		create_without_disable_update

		# Reenable updates to perform a single update
		GitHostingObserver.set_update_active(true);
	    end
	    # pre-1.4 (Non RESTfull)
	    def edit_with_disable_update
		# Turn of updates during repository update
		GitHostingObserver.set_update_active(false);

		# Do actual update
		edit_without_disable_update

		# Reenable updates to perform a single update
		GitHostingObserver.set_update_active(true);
	    end
	    # post-1.4 (RESTfull)
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
		GitHostingObserver.set_update_active(:delete => true);
	    end

	    # Need to make sure that we can re-render the repository settings page
	    # (Only for pre-1.4, i.e. single repo/project)
	    def render_with_trigger_refresh(*options, &myblock)
		doing_update = options.detect {|x| x==:update || (x.is_a?(Hash) && x[:update])}
		if !doing_update
		    render_without_trigger_refresh(*options, &myblock)
		else
		    # For repository partial
		    @repository ||= @project.repository
		    render_without_trigger_refresh *options do |page|
			yield page
			Page.replace_html "tab-content-repository", :partial => 'projects/settings/repository'
		    end
		end
	    end

	    def self.included(base)
		base.class_eval do
		    unloadable

		    helper :repositories
		end
		begin
		    # RESTfull (post-1.4)
		    base.send(:alias_method_chain, :create, :scm_settings)
		rescue
		    # Not RESTfull (pre-1.4)
		    base.send(:alias_method_chain, :new, :scm_settings) rescue nil
		end
		begin
		    # RESTfull (post-1.4)
		    base.send(:alias_method_chain, :update, :scm_settings)
		rescue
		    # Not RESTfull (pre-1.4)
		    base.send(:alias_method_chain, :edit, :scm_settings) rescue nil
		end
		base.send(:alias_method_chain, :destroy, :disable_update) rescue nil

		# This patch only needed when repository settings in same set
		# if tabs as members (i.e. pre-1.4, single repo)
		if !GitHosting.multi_repos?
		    base.send(:alias_method_chain, :render, :trigger_refresh) rescue nil
		end
	    end
	end
    end
end

# Patch in changes
MembersController.send(:include, GitHosting::Patches::MembersControllerPatch)
