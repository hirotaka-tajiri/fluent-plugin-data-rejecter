# encoding: UTF-8
require_relative 'spec_helper'
describe Fluent::DataRejecterOutput do

    before { Fluent::Test.setup }

    def create_driver(conf, tag='default.tag')
        Fluent::Test::OutputTestDriver.new(Fluent::DataRejecterOutput, tag).configure(conf)
    end

    let(:time_now) { Time.now }

    describe 'test config ' do

        it 'Check remove prefix AND add prefix AND reject_keys2' do
            d = create_driver %[
               remove_prefix abc
               add_prefix    123
               reject_keys   key1 key2
            ]
            d.instance.inspect
            expect(d.instance.remove_prefix).to eq "abc"
            expect(d.instance.add_prefix   ).to eq "123"
            expect(d.instance.reject_keys  ).to eq "key1 key2"
        end

    end

    describe 'Emit test ' do

        it 'tag change(remove & add)' do
            d = create_driver(%[
                                   remove_prefix abc
                                   add_prefix    123
                                   reject_keys   key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq '123.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq '123.def.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(remove. & add)' do
            d = create_driver(%[
                                   remove_prefix abc
                                   add_prefix    123.
                                   reject_keys   key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq '123.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq '123.def.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(remove & add.)' do
            d = create_driver(%[
                                   remove_prefix abc
                                   add_prefix    123.
                                   reject_keys   key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq '123.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq '123.def.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(remove. & add.)' do
            d = create_driver(%[
                                   remove_prefix abc.
                                   add_prefix    123.
                                   reject_keys   key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq '123.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq '123.def.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(no_remove & add)' do
            d = create_driver(%[
                                   add_prefix    123
                                   reject_keys   key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq '123.abc.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq '123.abc.def.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(remove & no_add)' do
            d = create_driver(%[
                                   remove_prefix abc
                                   reject_keys   key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq 'def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq 'def.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(remove_not_match & add)' do
            d = create_driver(%[
                                   remove_prefix xyz
                                   add_prefix    123
                                   reject_keys   key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq '123.abc.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq '123.abc.def.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(not_remove(not perfect match) & add)' do
            d = create_driver(%[
                                   remove_prefix ab
                                   add_prefix    123
                                   reject_keys   key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq '123.abc.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq '123.abc.def.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(all_remove & add)' do
            d = create_driver(%[
                                   remove_prefix old.tag
                                   add_prefix    new.tag
                                   reject_keys   key1
                               ], 'old.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq 'new.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq 'new.tag'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change(all_remove & no_addadd)' do
            d = create_driver(%[
                                   remove_prefix old.tag
                                   reject_keys   key1
                               ], 'old.tag')
            d.run do
                d.emit({'a' => 'b'},             time_now)
                d.emit({'c' => 'd', 'e' => 'f'}, time_now)
            end
            emits = d.emits
            expect(emits.size      ).to eq 2
            expect(emits[0][0]     ).to eq 'data_rejecter.tag_lost'
            expect(emits[0][2].size).to eq 1
            expect(emits[1][0]     ).to eq 'data_rejecter.tag_lost'
            expect(emits[1][2].size).to eq 2
        end

        it 'tag change & data reject1 & add)' do
            d = create_driver(%[
                                   remove_prefix abc
                                   add_prefix    123
                                   reject_keys   key
                               ], 'abc.def.tag')
            d.run do
                d.emit({'dat' => 'val'},                  time_now)
                d.emit({'dat' => 'val', 'key' => 'vl'},   time_now)
                d.emit({'dat' => 'val', 'key1' => 'vl1'}, time_now) 
            end
            emits = d.emits
            rlt   = {'dat' => 'val'}
            rlt1  = {'dat' => 'val', 'key1' => 'vl1'}
            expect(emits.size      ).to eq 3
            expect(emits[0][0]     ).to eq '123.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[0][2]     ).to eq rlt
            expect(emits[1][0]     ).to eq '123.def.tag'
            expect(emits[1][2].size).to eq 1
            expect(emits[1][2]     ).to eq rlt
            expect(emits[2][0]     ).to eq '123.def.tag'
            expect(emits[2][2].size).to eq 2
            expect(emits[2][2]     ).to eq rlt1
        end

        it 'tag change & data reject2 & add)' do
            d = create_driver(%[
                                   remove_prefix abc
                                   add_prefix    123
                                   reject_keys   key key1
                               ], 'abc.def.tag')
            d.run do
                d.emit({'dat' => 'val'},                                                    time_now)
                d.emit({'dat' => 'val', 'key'  => 'vl'},                                    time_now)
                d.emit({'dat' => 'val', 'key1' => 'vl1'},                                   time_now)
                d.emit({'dat' => 'val', 'key2' => 'vl2'},                                   time_now)
                d.emit({'dat' => 'val', 'key'  => 'vl',  'key1' => 'vl1'},                  time_now)
                d.emit({'dat' => 'val', 'key1' => 'vl1', 'key'  => 'vl'},                   time_now)
                d.emit({'dat' => 'val', 'key'  => 'vl',  'key1' => 'vl1', 'key2' => 'vl2'}, time_now)
                d.emit({'dat' => 'val', 'key'  => 'vl',  'key2' => 'vl2', 'key1' => 'vl1'}, time_now)
                d.emit({'dat' => 'val', 'key1' => 'vl1', 'key2' => 'vl2', 'key'  => 'vl'},  time_now)
            end
            emits = d.emits
            rlt   = {'dat' => 'val'}
            rlt1  = {'dat' => 'val', 'key2' => 'vl2'}
            expect(emits.size      ).to eq 9
            expect(emits[0][0]     ).to eq '123.def.tag'
            expect(emits[0][2].size).to eq 1
            expect(emits[0][2]     ).to eq rlt
            expect(emits[1][0]     ).to eq '123.def.tag'
            expect(emits[1][2].size).to eq 1
            expect(emits[1][2]     ).to eq rlt
            expect(emits[2][0]     ).to eq '123.def.tag'
            expect(emits[2][2].size).to eq 1
            expect(emits[2][2]     ).to eq rlt
            expect(emits[3][0]     ).to eq '123.def.tag'
            expect(emits[3][2].size).to eq 2
            expect(emits[3][2]     ).to eq rlt1
            expect(emits[4][0]     ).to eq '123.def.tag'
            expect(emits[4][2].size).to eq 1 
            expect(emits[4][2]     ).to eq rlt
            expect(emits[5][0]     ).to eq '123.def.tag'
            expect(emits[5][2].size).to eq 1
            expect(emits[5][2]     ).to eq rlt
            expect(emits[6][0]     ).to eq '123.def.tag'
            expect(emits[6][2].size).to eq 2
            expect(emits[6][2]     ).to eq rlt1
            expect(emits[7][0]     ).to eq '123.def.tag'
            expect(emits[7][2].size).to eq 2
            expect(emits[7][2]     ).to eq rlt1
            expect(emits[8][0]     ).to eq '123.def.tag'
            expect(emits[8][2].size).to eq 2
            expect(emits[8][2]     ).to eq rlt1
        end

  end


end
