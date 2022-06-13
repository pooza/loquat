# loquat

拙作[tomato-shrieker](https://github.com/pooza/tomato-shrieker)と併用して、[EPGStation](https://github.com/l3tnun/EPGStation)の録画予約に関するボットを作成できます。
以下、設定例。
```yaml
sources:
  - id: dai_reserve
    source:
      command:
        - bin/loquat.rb
        - reserves
        - ダイの大冒険
      dir: /home/pooza/repos/loquat
      delimiter: ---
    schedule:
      every: 1h
    dest:
      account:
        bot: true
      hooks:
        - https://mstdn.example.com/mulukhiya/webhook/xxxx
      spoiler_text: 放送予定（ネタバレ注意）
      tags:
        - ダイの大冒険
  - id: precure_reserve
    source:
      command:
        - bin/loquat.rb
        - reserves
        - プリキュア
      dir: /home/pooza/repos/loquat
      delimiter: ---
    schedule:
      every: 1h
    dest:
      account:
        bot: true
      hooks:
        - https://mstdn.example.com/mulukhiya/webhook/xxxx
      spoiler_text: 放送予定（ネタバレ注意）
      tags:
        - precure
        - プリキュア
  - id: recording
    source:
      command:
        - bin/loquat.rb
        - recording
      dir: /home/pooza/repos/loquat
      delimiter: ---
    dest:
      account:
        bot: true
      hooks:
        - https://mstdn.example.com/mulukhiya/webhook/xxxx
    schedule:
      every: 1m
```
