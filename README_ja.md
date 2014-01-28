#fluent-plugin-data-rejecter

## 概要

レコードよりkeyペアのエレメントを取り除くFluentdのプラグインです。

* keyペアのエレメントを取り除く
* tagの先頭を削除する
* tagの先頭を追加する

## 設定ファイルパラメーター

- remove_prefix

    tagの先頭が設定された文字列に一致した場合に該当部分を削除します。

- add_prefix

    出力時、tagの先頭に設定された文字列を追加します。

- reject_keys

    出力時、設定されたkeyペアのエレメントを取り除きます。
    スペース区切りで、同時に複数設定できます。

## 設定方法

例:

    <match abc.def.**>
        type          data_rejecter
        remove_prefix abc
        add_prefix    123
        reject_keys   key key1
    </match>

入力データ

    abc.def.tag: {"dat":"message", "key":"value", "key1":"value2", "key2":"value2", ....}

出力データ

    123.def.tag: {"dat":"message", "key2":"value2", ....}

### remove_prefix (完全一致のみ実行)

タグの先頭が、設定文字列で始まりタグの区切り文字(.)もしくは末端までが、完全に一致する場合にのみ一致部分を削除します。
先頭からの一部分のみが一致する場合にはタグの削除は行いません。



config  |  tag  #=> 実行結果

    abc  | abc.def.tag #=> 削除
    abc. | abc.def.tag #=> 削除
    ab   | abc.def.tag #=> 削除されません

## Copyright

Copyright (c) 2014 Hirotaka Tajiri. See [LICENSE](LICENSE.txt) for details.
