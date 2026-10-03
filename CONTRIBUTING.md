# Contributing

Thanks for helping improve BMI Calculator. Bug fixes, UI polish, clearer domain
rules, tests, and documentation are all welcome.

By participating you agree to the [Code of Conduct](CODE_OF_CONDUCT.md).

## What belongs here

This is a local Flutter app. Profiles and history stay on the device. There is
no account, no backend, and no ad or analytics SDK.

A good change does one of these:

- Fixes a calculation, validation, history, or profile bug
- Makes the Persian, right-to-left interface clearer or more accessible
- Tightens a use case or repository without changing the medical meaning by accident
- Adds a test for behavior that can regress

Talk about a large feature in an issue before you build it. That includes
anything that adds a network call, an account, a new storage backend, or a new
supported platform.

## What to leave alone

- Do not present BMI as a diagnosis. Adult bands follow WHO ranges. Ages under
  18 use youth copy and do not receive those adult bands. A change to either
  path needs a test and a note in the pull request.
- Do not put Flutter imports in `domain/`. Domain is plain Dart.
- Do not wipe stored profiles or history to recover from one bad row. Corrupt
  rows are skipped.
- History stays capped at 20 entries per profile unless an issue agrees
  otherwise.
- Vazirmatn stays under the SIL Open Font License. Do not relicense
  `assets/fonts/`.

## Branches

| Branch | Role |
| --- | --- |
| `main` | Stable, releasable history. Day-to-day work does not land here. |
| `dev` | Integration branch. Open pull requests against this branch. |

A release is a merge from `dev` into `main`. A fix made on the released line is
brought back to `dev`.

## Setup

Requirements are the same as the [README](README.md): Flutter stable, Dart SDK
`>=3.0.0 <4.0.0`, and Android Studio or VS Code. The repo targets Android, iOS,
and web.

```bash
git checkout dev
git pull
git checkout -b feature/your-change
flutter pub get
flutter test
```

Run the analyzer before you open a pull request:

```bash
flutter analyze
```

## Project shape

Feature-first Clean Architecture with an MVVM presentation layer. The
[README](README.md#architecture) has the directory map. The rules that reviews
enforce:

- **Domain** holds entities, use cases, and repository contracts. It does not
  import Flutter.
- **Data** implements those contracts. Profiles and history use
  `shared_preferences` through small local services.
- **Presentation** renders immutable state from `BmiViewModel` and
  `ProfileViewModel`. Widgets forward actions; they do not own the rules.
- `main.dart` is the composition root. Do not add a service locator.
- `go_router` owns routes. An incomplete profile stays on setup. The calculator,
  history, and profile tabs live in a `StatefulShellRoute`.

Shared color, type, spacing, motion, and Persian date formatting live in
`lib/design_system`. BMI-only theme values stay next to the BMI screens.

## Tests

`flutter test` is the check that must pass.

Add or update a test when you change a use case, a repository, validation, the
healthy-weight range, age interpretation, history, or profiles. Widget tests
belong with the screen they cover. Domain tests do not need Flutter bindings
beyond what the existing tests already use.

Name the behavior, not the method. A useful test says what input produces what
result, including the rejected cases: empty fields, non-numeric input, weight
outside 2–500 kg, and height outside 50 cm–2.5 m.

## Accessibility

Read [ACCESSIBILITY.md](ACCESSIBILITY.md) before changing a screen.

For UI work:

- Keep visible text in Persian, and keep the app right-to-left.
- Give an icon-only control a `Tooltip` or a `Semantics` label.
- Do not use color as the only sign of a BMI category. Pair it with text.
- Route motion through `AppMotion.durationOf` so reduced-motion settings win.
- Keep the primary controls at least `AppSpacing.control` (56 logical pixels)
  on the short side.

## Commits and pull requests

Write commit subjects in the imperative, as a sentence with a period:

```text
Add a test for youth readings under 18.
```

Open the pull request against `dev`. Fill in the pull request template. Say
what changed and why, and list how you tested it. Screenshots help for layout
changes. If a screenshot shows a profile or a reading, use sample data.

A review looks for:

- The pull request targets `dev`
- `flutter test` passes, and `flutter analyze` is clean for the files you touched
- Domain stays free of Flutter
- Behavior changes have a test
- UI copy stays Persian
- The medical disclaimer still matches the code

## Security

Report a vulnerability in private, using [SECURITY.md](SECURITY.md). Do not
file a public issue for an unfixed security bug.

## License

This project is [MIT licensed](LICENSE). Submitting a contribution means you
agree that your work is licensed under those terms. Vazirmatn remains under its
own license, `assets/fonts/OFL.txt`.
