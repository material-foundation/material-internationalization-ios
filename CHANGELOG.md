# 2.0.1

This patch release fixes framework-style imports when using bazel to build this library as an
external dependency.

## Non-source changes

* [Add workspace_root to framework import path. (#51)](https://github.com/material-foundation/material-internationalization-ios/commit/25a16214c9ca8ecfbb89f4168f7967c3a0549921) (featherless)

# 2.0.0

This major release upgrades the bazel dependencies and workspace. This change is breaking for anyone
using bazel to build this library. In order to use this library with bazel, you will also need to
upgrade your workspace versions to match the ones now used in this library's `WORKSPACE` file.

* [Update bazel workspace to latest versions. (#49)](https://github.com/material-foundation/material-internationalization-ios/commit/2ff10388f4a61c16a856092cdfba709ddbcdd2eb) (featherless)

# 1.1.1

* [Add MDFInternationalizationFrameworkHeaders as a dependency for bazel. (#47)](https://github.com/material-foundation/material-internationalization-ios/commit/580082c633f1e1146fd0634f02dcf39270c5375a) (featherless)
* [Integrate clang-format-ci. (#45)](https://github.com/material-foundation/material-internationalization-ios/commit/3ec6a305948a1bdac426e10811afbec691065341) (featherless)
* [Update to latest Xcode](https://github.com/material-foundation/material-internationalization-ios/commit/eb2107d3208f045d6464115f3cb5453d06a9c243) (Ian Gordon)
* [Update README.md](https://github.com/material-foundation/material-internationalization-ios/commit/39955811b952cc7a2f37201faeb38eeb3a239636) (ianegordon)

# 1.1.0

* [Add Bidi utilities (#42)](https://github.com/material-foundation/material-internationalization-ios/pull/42) (Ian Gordon)
* [Add support for relative paths to the Bazel build](https://github.com/material-foundation/material-internationalization-ios/pull/41) (Ian Gordon)
* [Bazel specific import paths are no longer required.](https://github.com/material-foundation/material-internationalization-ios/pull/38) (dmaclach)
* [Silence warnings (#37)](https://github.com/material-foundation/material-internationalization-ios/pull/37) (Ian Gordon)

# 1.0.4

* [[Bazel] Fix BUILD file SDK dependencies (#36)](https://github.com/material-components/material-components-ios/commit/298b51d3523a346a404e7e8c8bda14e27ed65226) (Robert Moore)

# 1.0.3

* [Add compile time flag for import style (#34)](https://github.com/material-foundation/material-internationalization-ios/88af44b587cb03408a827b97aa82234f6a7abc23) (ianegordon)
* [Add C++ guards so the compiler does not mangle symbol names. (#31)](https://github.com/material-foundation/material-internationalization-ios/5060976bcf45947d1176f8e060d13d4447b60a10) (Adrian Secord)
* [Remove framework-style headers from the umbrella header. (#30)](https://github.com/material-foundation/material-internationalization-ios/fef1a31313a4a8aa0234cce416e1615c7054cf9d) (featherless)
* [Add support for bazel and kokoro. (#27)](https://github.com/material-foundation/material-internationalization-ios/42a9bdf739a8de112fbcf8d395640f3477306fae) (featherless)
* [Silence NSNumber to BOOL conversion analyzer warning (#28)](https://github.com/material-foundation/material-internationalization-ios/5630a566396477ce6df5fd48b885aefdf40826d6) (ianegordon)
* [[RTL] Comment corrections and clarifications. (#26)](https://github.com/material-foundation/material-internationalization-ios/b6d5bfb53cac16de15c75d6571da5e15cdea4884) (Will Larche)

# 1.0.2

* [Update Project and Scheme to latest recommended settings](https://github.com/material-foundation/material-internationalization-ios/8a0317501403463fab8c1d541eddf0f649df2fc6) (Ian Gordon)
* [Update Travis-CI build environments and simulators (#24)](https://github.com/material-foundation/material-internationalization-ios/25521a9733fea64a2c9cde737d1037d2ec5eee74) (ianegordon)
* [Disable warnings added in Xcode 9 (#23)](https://github.com/material-foundation/material-internationalization-ios/6909be2fcde579116d7e454ae308dac777b740bb) (ianegordon)

# 1.0.1

* [Modify sharedApplication call to avoid extension error (#17)](https://github.com/material-foundation/material-internationalization-ios/commit/902e392e78c11e8ae5169135dd7a0077bcf37d48) (ianegordon)

# 1.0.0

Initial release.

