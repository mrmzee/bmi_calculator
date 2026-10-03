# Accessibility

BMI Calculator should be usable with the system settings a person already
relies on: text size, light or dark theme, reduced motion, and a screen reader.
The interface is Persian and right-to-left on Android, iOS, and web.

This file is a statement of intent and of what the app does today. It is not a
conformance certificate. No third party has audited the app against WCAG, and
this project does not claim a WCAG level.

## What the app does today

- **Language and direction.** `MaterialApp` sets the title in Persian, and the
  tree is wrapped in a right-to-left `Directionality`. Dates and digits are
  formatted for that interface. The bundled typeface is Vazirmatn.
- **Theme.** Light and dark themes follow the system. Both are Material 3.
- **Screen reader names.** The BMI value, the category scale, the dial, and the
  history chart expose Persian semantics labels. The category scale announces
  the current band in words, not only by color. Unit choices are buttons with
  a tooltip and a selected state. The tabs are labeled محاسبه، تاریخچه، and
  پروفایل.
- **Motion.** Durations go through `AppMotion.durationOf`. When the system asks
  to reduce motion, those durations become zero.
- **Targets.** The primary action and the unit choices use a minimum size of
  `AppSpacing.control`, which is 56 logical pixels.
- **Text size.** The app does not install its own text scaler, so the system
  text size is left to Flutter.

## Known limitations

- **Persian only.** Screen-reader language follows the device, but the strings
  in the app are Persian. A non-Persian voice may spell them poorly.
- **Large text.** Compact layouts, including the dial, can crowd or clip when
  the system text size is very large. That is an open gap.
- **Color.** Status color still appears on the dial and the category scale. It
  is paired with a text label on the result, and it should stay that way.
- **Platforms.** Android, iOS, and web are the supported surfaces. Desktop is
  not a maintained target.
- **System UI.** The share sheet, permission prompts, and OS text-size controls
  belong to the platform.

## Reporting a barrier

Open an [accessibility issue](https://github.com/mrmzee/bmi_calculator/issues/new/choose)
or email [kopo0074@gmail.com](mailto:kopo0074@gmail.com). English or Persian is
fine.

Please include:

- Platform and OS version
- Assistive technology, if any (TalkBack, VoiceOver, a browser screen reader,
  Switch Access, keyboard)
- Text size, theme, and reduced-motion settings
- What you were trying to do, and what the app did instead

The maintainer aims to reply within 7 business days. A report can become a
normal pull request against `dev`.

Do not include another person's measurements or profile name. Sample values are
enough.

## Expectations for changes

UI changes should follow the accessibility section of
[CONTRIBUTING.md](CONTRIBUTING.md). In short: Persian copy, right-to-left
layout, a name for every icon-only control, text beside status color, motion
that honors the system setting, and primary targets at least 56 logical pixels.
