# terraform-provider-logto

## CCSN Crossplane integration fork

Maintained at [the-ccsn/terraform-provider-logto](https://github.com/the-ccsn/terraform-provider-logto), based on [Lenstra v0.0.15](https://github.com/Lenstra/terraform-provider-logto). It adds a public `provider.New` entry point,
`logto_application_secret` for named-secret CRUD/import, and a computed sensitive
`client_secrets` map on applications. It corrects token caching and expiry units,
omits credential-bearing HTTP logs/response bodies, marks the management app
secret sensitive, and handles missing roles without dereferencing nil.

Client live tests now require `TF_ACC=1`, matching the Terraform acceptance tests.
Ordinary `go test ./...` uses no real Logto credentials. Offline lifecycle tests
use a simulated transport. See [provider-upjet-logto](https://github.com/the-ccsn/provider-upjet-logto) for
CRDs, examples, regeneration and verification commands. Fork additions are not available from the upstream Terraform Registry release.
The Go module path is retained for compatibility with the embedded Upjet provider.

Migration additions include explicit resources for sign-in experience,
account center, ID-token extended claims, OIDC session settings and connectors.
Their configuration JSON owns only the specified fields. Connector configuration
is sensitive; singleton deletion releases ownership without resetting settings.
Applications also expose validated JSON for additional OIDC and token metadata.

`logto_application_user_consent_scopes` manages the allowed user profile scopes
of a third-party application, including `profile` and `email`. One resource owns
all user profile scopes of an application; API and organization consent scopes
are preserved. Refresh detects drift, updates reconcile grants in place, and an
explicit empty set revokes all user profile scopes. Import uses the application
ID. Users still approve access on the consent screen.

## Quality gates

`make verify` runs offline lifecycle and protocol tests with the race detector,
`go vet`, and a binary build. `make lint` runs staticcheck and `make security`
runs govulncheck. CI runs these without credentials and checks generation drift.
Acceptance tests remain opt-in and must target a disposable Logto tenant.

`provider_code_spec.json` is the reviewed source of generated schemas.
`make generate` uses framework generator v0.4.1 and never fetches the moving
Logto OpenAPI document. `config/provider_code_extra.json` and the OpenAPI mapping
are retained as historical migration inputs; they no longer override the schema.
The handwritten application-secret, user-consent-scopes and configuration resources own their schemas and are excluded
from generated implementations. Review schema changes before regenerating Upjet.

Role scope changes now reconcile relations in place. Empty scope or user role
lists revoke all managed assignments. Application and user metadata PATCHes
preserve fields that this fork does not manage. All deletes accept absence.

The fork requires Go 1.25 or newer after security dependency upgrades. CI uses
Go 1.26.8. Signed Terraform Registry releases remain disabled pending signing
credentials and release validation; the manual release-readiness workflow only validates.

Omitted optional fields preserve prior state during updates; use explicit empty
strings or lists to clear managed values. Generation also patches the pinned
generator's null/unknown object conversion using Go AST; protocol regressions
verify nested state preservation.

See [quality review](docs/quality-review.md) for verified checks and remaining
production release gates.

## Real acceptance tests

CI provisions Logto 1.40.1 and PostgreSQL 17.11 with temporary loopback-only
credentials. Real protocol tests use the `integration` build tag and
`LOGTO_TEST_CREDENTIALS`; `make test-integration` validates the six original resources,
import, pagination beyond 100 entries and unmanaged metadata preservation.
It also verifies all five new configuration API contracts against Logto 1.40.1;
offline protocol tests cover their create, update, import, read and deletion behavior.
Do not use production credentials for acceptance tests.

## License

MIT; upstream copyright and license are retained in [LICENSE](LICENSE).
