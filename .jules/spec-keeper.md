## 2024-05-23 - Bolt Pattern Ambiguity on GD Platform

**Learning:** The GD platform (2002-2007 Impreza/WRX/STI) has a split in wheel bolt patterns that is a common source of error. 2004 STI is 5x100, while 2005-2007 STI is 5x114.3. All non-STI GDs are 5x100. This requires distinct tags and verified rows to prevent incorrect parts purchasing.

**Action:** Explicitly separated 2004 STI specs from 2005+ STI specs using tags (`gd`, `sti`, `2004` vs `2005`). Added strict validation for bolt pattern existence on major platforms.
