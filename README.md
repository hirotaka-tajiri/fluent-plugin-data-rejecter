#fluent-plugin-data-rejecter

## Overview

Output plugin to reject key pairs

* reject key pairs
* remove tag prefix
* add tag prefix

## Configuration
### Parameters

- remove_prefix

    remove tag if tag matches this pattern

- add_prefix

    add tag for re-emit.

- reject_keys

    reject key pair for re-emit.

### Example

    <match abc.def.**>
        type          data_rejecter
        remove_prefix abc
        add_prefix    123
        reject_keys   key key1
    </match>

input

    abc.def.tag: {"dat":"message", "key":"value", "key1":"value2", "key2":"value2", ....}

output

    123.def.tag: {"dat":"message", "key2":"value2", ....}

### remove_prefix (complete matching)

config  |  tag  #=> result

    abc  | abc.def.tag #=> removed
    abc. | abc.def.tag #=> removed
    ab   | abc.def.tag #=> not removed

## Copyright

Copyright (c) 2014 Hirotaka Tajiri. See [LICENSE](LICENSE.txt) for details.
