[ORY Hydra][hydra] OAuth2 token server. Ready for Reaction development.

### Part of the Reaction Platform

This application is a part of the Reaction Platform and is designed to work
with other services. You can launch Reaction and it's dependencies with a
single command by using the [Reaction Platform][reaction-platform] development
installation.

#### [See the Reaction Platform README to get started quickly.][reaction-platform]

[reaction-platform]: https://github.com/reactioncommerce/reaction-platform

## Project Status

This project is experimental.

* :warning: Not yet suitable for local development
* :warning: Contains specific configuration for the Reaction Platform.
* :boom: Not intended for production.

## Services

These services will be available when the project is started:

| Service                                                           | Description                                                                                                         |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| **[Hydra Public API][hydra-public-api]**<br>http://localhost:4444 | Hydra's public API. It can be exposed to the public internet.                                                       |
| **[Hydra Admin API][hydra-admin-api]**<br>http://localhost:4445   | Hydra's administration API. This is unprotected and should not be exposed to the internet without a secure gateway. |
| **[Hydra Token API][hydra-public-api]**<br>http://localhost:5555  | Service for the Hydra token user.                                                                                   |

[hydra-public-api]: http://localhost:4444
[hydra-admin-api]: http://localhost:4445
[hydra-token-api]: http://localhost:5555

## License

Copyright © Reaction Commerce

[ory/hydra][hydra] is licensed under
[Apache License 2.0](https://github.com/ory/hydra/blob/master/LICENSE)

[hydra]: https://github/ory/hydra
