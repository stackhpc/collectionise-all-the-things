# Collectionise all the things

Utilities to help adding standalone Ansible roles to collections.

## HOWTO

* Check for any open PRs or issues in the role.
* Choose a name for the role in the collection. It cannot include dashes (`-`)
* Clone the target collection
* Clone the role to be added
* Clone this repository next to your collection
* Change to the collection root directory
* Create a new branch for the change
* Add the role content:
  ```sh
  ../collectionise-all-the-things/collectionise.sh <path/to/role> <new role name>
  ```
* Run sanity tests, fix issues and commit changes:
  ```sh
  ../collectionise-all-the-things/collection-sanity.sh
  ```
* Run ansible-lint in auto-fix mode:
  ```sh
  ansible-lint --fix
  ```
* Inspect changes, adapt and commit.
* Fix any remaining ansible-lint issues and commit.
* Inspect the role for any other changes, modernisation, etc.
* Update the role's README.
* Add the role to the list of roles in the collection's main README.
* Check sanity tests and ansible-lint again.
* Test the role.
* Create a PR.
* Mark the role as deprecated, and archive the repository.
