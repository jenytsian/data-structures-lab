# 左閉右閉 vs. 左閉右開

標籤：#區間 #二分搜 #雙指標 #排序 ｜ 課本：Ch1 Program 1.7 ｜ 題目：001-recursion-basics (4) binsearch、(5) lower_bound_r

## 一句話

先決定 `right` 算不算在區間裡，其他四件事（怎麼呼叫、何時為空、長度、怎麼縮）都跟著推得出來，不用背。

## 核心觀念

二分搜、滑動視窗、雙指標、QuickSort、MergeSort，只要碰到區間都問這五個問題：

| 問題 | 左閉右閉 `[left, right]` | 左閉右開 `[left, right)` |
|---|---|---|
| ① 定義 | `left`、`right` 都在範圍內 | 包含 `left`，不包含 `right`（`right` 是範圍外第一格） |
| ② 怎麼呼叫（長度 n） | `f(0, n - 1)`：最後一個合法 index 是 n-1 | `f(0, n)`：n 不包含，實際是 0 到 n-1 |
| ③ 何時為空 | `left > right`。`[3, 3]` 還有一個元素 | `left == right`。`[3, 3)` 是 0 個元素 |
| ↳ 迴圈條件 | `while (left <= right)` | `while (left < right)` |
| ④ 長度 | `right - left + 1` | `right - left` |
| ⑤ mid 排除後怎麼縮 | 左縮 `right = mid - 1`，右縮 `left = mid + 1` | 左縮 `right = mid`，右縮 `left = mid + 1` |
| 誰在用 | 課本 Program 1.7 | C++ STL、Python、001 的 lower_bound_r |

**⑤ 的道理**：mid 已經檢查過，新區間不能再包含 mid。

- 動左界：左邊是閉的，寫 `mid` 會包含它，所以兩種寫法都是 `left = mid + 1`
- 動右界：
  - 閉的寫 `mid` 會包含，要 `mid - 1`
  - 開的寫 `mid` 剛好不包含 `[left, mid)`，而且 mid 留在 `right` 上當備用答案（lower_bound 就靠這個）

口訣：**左閉改 `mid + 1`，右開改 `mid`**

## 程式碼

```c
// 左閉右閉：找 key，找不到回傳 -1
int l = 0, r = n - 1;
while (l <= r) {
    int mid = l + (r - l) / 2;          // 不寫 (l + r) / 2，避免 overflow
    if (a[mid] == key) return mid;
    if (a[mid] < key) l = mid + 1;
    else r = mid - 1;
}
return -1;

// 左閉右開：lower_bound，第一個 >= key 的位置，全部都小於 key 回傳 n
int l = 0, r = n;
while (l < r) {
    int mid = l + (r - l) / 2;
    if (a[mid] < key) l = mid + 1;      // mid 太小，不是答案
    else r = mid;                       // mid 可能是答案，留在 r 上
}
return l;                               // 結束時 l == r
```

001 不能用迴圈，要把上面改成遞迴：迴圈條件變成 base case，`l = ...`、`r = ...` 變成遞迴呼叫的參數。

## 易錯點

- 閉區間寫 `while (l < r)` → `l == r` 那一格沒檢查到，答案在最後一格時會漏掉
- 開區間寫 `r = mid - 1` → 把 `mid - 1` 也排除了，可能剛好跳過答案
- 開區間寫 `while (l <= r)` 搭配 `r = mid` → `l == r` 時 mid 就是 l，`r = mid` 區間不變，無窮迴圈
- 呼叫跟定義不一致：寫開區間卻用 `f(0, n - 1)` 呼叫，最後一格永遠看不到

## 自我檢查

1. `[2, 5]` 和 `[2, 5)` 各有幾個元素？
2. 左閉右開的 lower_bound，為什麼 `a[mid] >= key` 時寫 `r = mid` 而不是 `r = mid - 1`？
3. MergeSort 用左閉右開時，`[l, r)` 從中間切開，兩半怎麼寫？

<details><summary>答案</summary>

1. `[2, 5]`：5 - 2 + 1 = 4 個；`[2, 5)`：5 - 2 = 3 個
2. mid 可能就是答案，不能丟掉。`r = mid` 讓區間變成 `[l, mid)`，mid 不在未知區域裡，但存在 `r` 上，最後 `l` 追到 `r` 就是它
3. `m = l + (r - l) / 2`，兩半是 `[l, m)` 和 `[m, r)`，不用 ±1，接起來剛好不重疊也不漏

</details>

## 相關

- 課本 Program 1.7 / 1.8 binsearch（左閉右閉）
