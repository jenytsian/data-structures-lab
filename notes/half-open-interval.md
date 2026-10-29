# 左閉右開：right 是保底答案

用 `[left, right)` 找「第一個滿足條件的位置」時，`right` 是目前已知合法的保底答案，`[left, right)` 是還沒檢查、可能藏著更好答案的未知區間。整個二分搜就是不斷縮小未知區間，同時把保底答案換成更好的。

## 為什麼 right = mid

`mid` 符合條件，它就是一個合法答案，而且比原本的 `right` 更靠左、更好，所以把它收進保險箱：`right = mid`。`mid` 已經檢查過，不再屬於未知區間，未知區間就變成 `[left, mid)`。

數學上答案落在 `[left, mid]`，程式寫的卻是 `[left, mid)`。少掉的那一格沒有丟，它就存在 `right` 上。

## 為什麼 left = mid + 1

`mid` 不符合條件。陣列有序，所以 `mid` 左邊的也全部不符合，`mid` 連同左邊一起出局。`left` 是閉的，要把 `mid` 排除只能寫 `mid + 1`。

## 一開始的保底是什麼

`right` 一開始是 `n`，陣列外面那一格，代表「全部都不符合時的答案」。`lower_bound` 找不到時回傳 `n`，就是因為保險箱裡從頭到尾都還是這個初值。

換成對答案二分搜（船的最小載重、吃香蕉的最小速度），`right` 的初值就要選一個一定合法的值，例如所有貨物的總重。初值選錯，保險箱裡放的就不是答案。

## 什麼時候停

`left == right` 時未知區間是空的，沒有更好的答案可以找，直接打開保險箱回傳 `right`。所以迴圈條件是 `left < right`。

只要 `left < right`，`mid = left + (right - left) / 2` 一定小於 `right`，所以 `a[mid]` 不會讀到 `a[n]`。每一輪不是 `right` 變小就是 `left` 變大，迴圈一定會結束。

## 程式碼

```c
int lower_bound(int a[], int n, int key) {
    int left = 0, right = n;              // 保底：全部都 < key 就是 n
    while (left < right) {                // 未知區間還有東西
        int mid = left + (right - left) / 2;
        if (a[mid] >= key) right = mid;   // mid 合法，收進保險箱
        else left = mid + 1;              // mid 不合法，連同左邊一起排除
    }
    return right;
}
```

`upper_bound` 只要把條件換成 `a[mid] > key`。對答案二分搜則把條件換成「`mid` 可不可行」，例如 `canShip(mid)`。

## 同一種切法

MergeSort 把 `[left, right)` 切成 `[left, mid)` 和 `[mid, right)`。兩段頭尾相接，不重複也不漏，長度 `mid - left` 加 `right - mid` 剛好是 `right - left`。滑動視窗從空的 `[0, 0)` 開始，`right` 指向下一個要進來的元素，視窗長度永遠是 `right - left`。

這兩個地方的 `right` 不是保底答案，但「`right` 不在區間裡」這件事一樣讓邊界不用 ±1。
