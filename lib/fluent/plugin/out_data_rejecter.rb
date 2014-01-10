module Fluent
    class DataRejecterOutput < Output
        Fluent::Plugin.register_output('data_rejecter', self)

        config_param :remove_prefix, :string, :default => ''
        config_param :add_prefix,    :string, :default => ''
        config_param :reject_keys,   :string, :default => ''

        def configure(conf)
            super

            @remove = @remove_prefix.end_with?('.') ? @remove_prefix : @remove_prefix + '.'
            @add    = @add_prefix.end_with?('.')    ? @add_prefix    : @add_prefix    + '.'
            @add_p  = @add.chop
        end

        def emit(tag, es, chain)

            tmptag = (tag[@remove.size .. -1] if tag.start_with?(@remove)) || (tag == @remove_prefix ? '' : tag)
            tag    = @add_p.size.zero? ? (tmptag.size.zero? ? "data_rejecter.tag_lost" : tmptag) : (tmptag.size.zero? ? @add_p : @add + tmptag)

            es.each {|time,record|
                Engine.emit(tag, time, reject_record(record))
            }

            chain.next
        end

      private
        def reject_record(record)

            @reject_keys.split.each{| v | record.delete(v) if record.has_key?(v)}
            record
        end
    end
end
