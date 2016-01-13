Promise Plugin for Fuel
============

Promise plugin
-----------------------

Overview
--------

This will install Promise onto the OpenStack controller for Resource Management for Virtual Infrastructure

* [OPNFV Promise](https://wiki.opnfv.org/promise) Resource Management

Requirements
------------

| Requirement                      | Version/Comment |
|----------------------------------|-----------------|
| Mirantis OpenStack compatibility | 7.0             |

Recommendations
---------------

None.

Installation Guide
==================

Promise plugin installation
----------------------------------------

1. Clone the fuel-plugin-promise repo from github:

        git clone https://github.com/opnfv/fuel-plugin-promise.git

2. Install the Fuel Plugin Builder:

        pip install fuel-plugin-builder

3. Build Promise Fuel plugin:

        fpb --build fuel-plugin-promise/

4. The *fuel-plugin-promise-x.x.x.fp* plugin package will be created in the plugin folder.
  
5. Move this file to the Fuel Master node with secure copy (scp):

        scp fuel-plugin-promise-x.x.x.fp root@<the_Fuel_Master_node_IP address>:/tmp

6. While logged in Fuel Master install the Promise plugin:

        fuel plugins --install /tmp/fuel-plugin-promise-x.x.x.fp

7. Check if the plugin was installed successfully:

        fuel plugins

        id | name                | version | package_version
        ---|---------------------|---------|----------------
        1  | fuel-plugin-promise | 1.0.0   | 1.0.0

8. Plugin is ready to use and can be enabled on the Settings tab of the Fuel web UI.

## License
  [Apache-2.0](LICENSE)
