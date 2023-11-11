# Verilog環境とテンプレート

- Verilog/SystemVerilogで回路を記述し、テストベンチを書いてシミュレーション
- 波形ビューワーで波形確認を行う
- DUT(Design Under Test)へのランダムな値の入力とSVA(System Verilog Assertio)のテスト


# 実行方法

「sim/」内に入り`./sim test_pattern`のように「tp/」以下で記述したテストパターンを引数に与え、スクリプトを実行する
- 例：`./sim test_01`

# 参考

- インストール/ダウンロード方法
    - `visvado -version` : vivado v2023.1 (64-bit)
    - https://www.xilinx.com/support/download.html
    - https://www.acri.c.titech.ac.jp/wordpress/archives/3403

# ディレクトリ説明

- rtl
    - 回路記述
- sim
    - シミュレーションを行う場所
- sva
    - アサーションの記述と接続ファイル
- tb
    - テストベンチ
- tp
    - テストパターンの記述
    - テストベンチでincludeされる
