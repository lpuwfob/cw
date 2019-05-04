# cw

All the course works are pushed in this repository.

- NTU SPMS
  - CZ2007: Introduction to Database
  - CZ3005: Artificial Intelligent
  - MH3512: Stochastic Process
  - MH4501: Multivariate Analysis
  - MH4510: Statistical Learning and Data Mining
  - MH4514: Financial Mathematics

# README.md

## ソースコードのビルド方法(src\)

- data_loader.py
  - train、及びtestデータの読み込み
- log.txt
  - ロス計算の遷移のメモ
- main.py
  - GNNの実行、及びprediction.txtへの書き出し
- model.py
  - GNNクラスの実装
- README.md
  - このファイル。ソースコードの説明と実行方法の記述
- util.py
  - GNNクラス実装のための関数、及びSGD, Momentum, Adamクラスの実装
- demo.ipynb
  - Jupyter Notebookによる課題1~4への解答


## 実行方法

- 課題1,2
  - demo.ipynb
- 課題3,4
  - demo.ipynb
  - main.py
   - optimizerに、SGD, Momentum, もしくはAdamを代入することで、パラメータ更新の方法を変更できます。
