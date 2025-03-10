## 本機環境

### 建置
1. 建 [k3d cluster](https://hackmd.io/247PuafWT3eRMPcJw2hQgQ)。
2. 安裝 [istio](https://hackmd.io/ppdTYAmnQNqCDOakqspbtQ)。 
3. 安裝 [kyverno](https://hackmd.io/LK2e747aQ9OmWAcj_ilaTA)。 
4. 安裝 [argocd](https://hackmd.io/zdcctXp5Szm3aBF6llj7Jg)。
5. 安裝各 applications：
  ```bash
  make connect
  make install
  ```

### 驗證
參考[這邊](https://hackmd.io/GVDvm2AoTcefk0ytgUQ3kQ)。
1. 建置 service 及 rabbitmq source。
2. 從 rabbitmq management 建立 queue。
3. 對 qeueue 發送訊息。
4. 從 service log 看有沒有收到 cloud event。

### 開發
1. 可以先安裝 [vscode helm](https://marketplace.visualstudio.com/items?itemName=technosophos.vscode-helm)
> 寫 helm template 的時候才不會噴錯。

### 參考
- https://medium.com/@mprzygrodzki/argocd-applicationsset-with-helm-72bb6362d494
- https://medium.com/starbugs/argo-cd-applicationset-controller-%E4%B8%96%E7%95%8C%E7%82%BA%E6%88%91%E8%80%8C%E8%BD%89%E5%8B%95-a837f9392298

### 各種 why
#### istio
Kourier 不支援 sticky sessions，所以 WebSocket 連線中可能會被重新分配到不同 pod，導致斷線。
1. 換用 Istio，設定 sessionAffinity。
2. 設計無狀態架構，將 WebSocket session 狀態存外部（如 Redis）。
3. 固定 Knative pod 數量（將 `autoscaling.knative.dev/minScale` 和 `autoscaling.knative.dev/maxScale` 設為同樣的正整數），避免因為 scale in 導致的中斷。