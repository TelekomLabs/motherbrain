module MotherBrain
  class ApiClient
    # @author Jamie Winsor <reset@riotgames.com>
    class EnvironmentResource < ApiClient::Resource
      # @param [String] id
      #   name of the environment to update
      # @param [String] plugin
      #   name of the plugin to use
      # @param [Bootstrap::Manifest] manifest
      #
      # @option options [String] :version
      #   version of the plugin to use
      # @option options [String] :chef_version
      #   version of Chef to install on the node
      # @option options [String] :installer_url
      #   location of the Omnibus install.sh
      # @option options [Hash] :component_versions (Hash.new)
      #   Hash of components and the versions to set them to
      # @option options [Hash] :cookbook_versions (Hash.new)
      #   Hash of cookbooks and the versions to set them to
      # @option options [Hash] :environment_attributes (Hash.new)
      #   Hash of additional attributes to set on the environment
      # @option options [Boolean] :force
      # @option options [Array] :hints
      def bootstrap(id, plugin, manifest, options = {})
        body = {
          manifest: manifest,
          plugin: {
            name: plugin,
            version: options[:version]
          }
        }.merge(options.except(:version))

        json_put("/environments/#{id}.json", MultiJson.encode(body))
      end

      # Configure a target environment with the given attributes
      #
      # @param [#to_s] id
      #   identifier for the environment to configure
      #
      # @option options [Hash] :attributes (Hash.new)
      #   a hash of attributes to merge with the existing attributes of an environment
      # @option options [Boolean] :force (false)
      #   force configure even if the environment is locked
      #
      # @note attributes will be set at the 'default' level and will be merged into the
      #   existing attributes of the environment
      def configure(id, options = {})
        body = {
          attributes: options[:attributes],
          force: false
        }

        json_post("/environments/#{id}/configure.json", MultiJson.encode(body))
      end

      # @param [String] id
      def destroy(id)
        json_delete("/environments/#{id}.json")
      end

      def get(id)
        json_get("/environments/#{id}.json")
      end

      # Return a list of all the environments
      #
      # @return [Array]
      def list
        json_get("/environments.json")
      end

      # Lock the target environment
      #
      # @param [String] id
      #   identifier for the environment to lock
      def lock(id)
        json_post("/environments/#{id}/lock.json")
      end

      # @param [String] id
      #   name of the environment to create
      # @param [String] plugin
      #   name of the plugin to use
      # @param [Provisioner::Manifest] manifest
      #
      # @option options [String] :version
      #   version of the plugin to use
      # @option options [String] :chef_version
      #   version of Chef to install on the node
      # @option options [String] :installer_url
      #   location of the Omnibus install.sh
      # @option options [Hash] :component_versions (Hash.new)
      #   Hash of components and the versions to set them to
      # @option options [Hash] :cookbook_versions (Hash.new)
      #   Hash of cookbooks and the versions to set them to
      # @option options [Hash] :environment_attributes (Hash.new)
      #   Hash of additional attributes to set on the environment
      # @option options [Boolean] :skip_bootstrap (false)
      #   skip automatic bootstrapping of the created environment
      # @option options [Boolean] :force (false)
      #   force provisioning nodes to the environment even if the environment is locked
      def provision(id, plugin, manifest, options = {})
        body = options.merge(
          manifest: manifest,
          plugin: {
            name: plugin,
            version: options[:version]
          }
        )
        
        json_post("/environments/#{id}.json", MultiJson.encode(body))
      end

      # Unlock the target environment
      #
      # @param [String] id
      #   identifier for the environment to unlock
      def unlock(id)
        json_delete("/environments/#{id}/lock.json")
      end

      # Upgrade the target environment
      #
      # @param [String] id
      #   name of the environment to create
      # @param [String] plugin
      #   name of the plugin to use
      # @param [String] version
      #   version of the plugin to use
      #
      # @option options [Hash] :component_versions
      #   Hash of components and the versions to set them to
      # @option options [Hash] :cookbook_versions
      #   Hash of cookbooks and the versions to set them to
      # @option options [Hash] :environment_attributes
      #   Hash of additional attributes to set on the environment
      # @option options [Boolean] :force
      #   force provisioning nodes to the environment even if the environment is locked
      def upgrade(id, plugin, version, options = {})
        options.slice!(:component_versions, :cookbook_versions, :environment_attributes, :force)
        body = options.merge(
          plugin: {
            name: plugin,
            version: version
          }
        )

        json_post("/environments/#{id}/upgrade.json", MultiJson.encode(body))
      end
    end
  end
end
