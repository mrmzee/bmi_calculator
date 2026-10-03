# Security Policy

BMI Calculator keeps profiles and history on the device. The app has no
account, no server, and no analytics. A security report is still welcome when
something in this repository can expose or corrupt that local data, or can run
untrusted code.

## Supported versions

| Line | Supported |
| --- | --- |
| `main` | Yes. This is the released line. |
| `dev` | No. It is the integration branch and is not a security support line. |
| Older history than current `main` | No. |

There is no long-term support branch. A fix ships by landing on `dev` and then
merging `dev` into `main`.

## In scope

- Reading or changing another person's profiles or history beyond what the
  operating system already allows for local app storage
- Unsafe handling of a profile name, a goal weight, or text sent to the system
  share sheet
- A dependency in `pubspec.yaml` with a known vulnerability that affects the
  shipped app
- The web build, when user-controlled text can execute as code

## Out of scope

- The medical meaning of BMI, WHO bands, or youth copy. Those belong in a
  normal issue. The app is not a diagnosis.
- A missing feature, including the lack of a server or an account
- A device that is rooted, jailbroken, or already compromised
- Physical access to an unlocked device
- The operating system's share sheet after the text has left the app
- Social engineering against the maintainer

## Reporting

Do not open a public issue, pull request, or discussion for an unfixed
vulnerability.

Email [kopo0074@gmail.com](mailto:kopo0074@gmail.com) with the subject
`[SECURITY] BMI Calculator`, or open a
[private security advisory](https://github.com/mrmzee/bmi_calculator/security/advisories/new).

Include:

- What is affected, and which commit on `main` you tested
- Platform: Android, iOS, or web
- Steps to reproduce
- The impact, and whether you have a suggested fix

Sample profile names and sample measurements are enough. Do not send someone
else's health data.

## Response

The maintainer aims to acknowledge a report within 3 business days and to send
a fuller update within 14 days. Those are targets for a single-maintainer
project, not a contractual service level.

If the report is accepted, the fix is prepared on `dev` and released through
`main`. You will be credited in the release note unless you ask to stay
anonymous. There is no bug bounty.

Please give the maintainer a chance to ship a fix before you publish details.
