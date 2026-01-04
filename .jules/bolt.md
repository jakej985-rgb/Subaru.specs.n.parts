## 2024-05-23 - [ValueListenableBuilder for Suffix Icons]
**Learning:** Using `addListener` + `setState` on a `TextEditingController` to toggle suffix icons (like clear buttons) causes full widget rebuilds on every keystroke. Using `ValueListenableBuilder` listening to the controller restricts rebuilds to just the icon button.
**Action:** Always wrap `suffixIcon` in `ValueListenableBuilder<TextEditingValue>` when its state depends on the controller's text.
