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

## 說明
1. Network Layer 選用 istio。確保接下來如果有 WebSocket 的應用，可以設定 Session Affinity。
  > 應將 `autoscaling.knative.dev/minScale` 和 `autoscaling.knative.dev/maxScale` 設置為同樣的正整數，避免因為 scale in 導致的中斷。
2. 透過 Kyverno 將 namespace 安裝在特定節點上。
3. 用 argocd 作 gitops。
4. 在 Knative 中，讓 Eventing 用的 Service 只能接收來自內部 Source 的請求。
5. 用 debezium 對 RDBMS 作 CDC（`db -> cdc exchange -> queue`, routing key 是 `mysql.{database}.{table}`）。
6. 不同主專案用 namespace 切開，不同子專案用 chart 切開。