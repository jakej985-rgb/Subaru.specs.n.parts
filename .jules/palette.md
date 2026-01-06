## 2024-02-14 - Keyboard Dismissal on Search Results
**Learning:** Mobile users often search for a term and immediately scroll to see results, but the virtual keyboard obscures 40-50% of the viewport. Manually dismissing it is a high-friction action.
**Action:** Apply `keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag` to all search result `ListView`s to create a native, polished feel where the content takes priority on interaction.
