module ApplicationHelper
    # スクレイピング時の残り
    # require 'open-uri'
    # require 'uri'
    
    # charset = 'utf-8'
    # errors = []
    # pokemons = Pokemon.where(id: 952..Float::INFINITY)
    # # pokemons = [
    # #   "ア","イ","ウ","エ","オ",
    # #   "カ","キ","ク","ケ","コ",
    # #   "サ","シ","ス","セ","ソ",
    # #   "タ","チ","ツ","テ","ト",
    # #   "ナ","ニ","ヌ","ネ","ノ",
    # #   "ハ","ヒ","フ","ヘ","ホ",
    # #   "マ","ミ","ム","メ","モ",
    # #   "ヤ","ユ","ヨ",
    # #   "ラ","リ","ル","レ","ロ",
    # #   "ワ","ヲ","ン",
    # # ]
    # pokemons.each do |pokemon|
    #   # res = URI.encode pokemon.name
    #   res = URI.encode pokemon.name
    #   html = open("https://wiki.xn--rckteqa2e.com/wiki/#{res}") { |f| f.read }
    #   # html = open("https://wiki.xn--rckteqa2e.com/wiki/%E3%81%A8%E3%81%8F%E3%81%9B%E3%81%84%E4%B8%80%E8%A6%A7") { |f| f.read }
    #   doc = Nokogiri::HTML.parse(html, nil, charset)
    #   add_list = []
    #   # <br>タグを改行（\n）に変えて置くとスクレイピングしやすくなる。
    #   doc.search('br').each { |n| n.replace("\n") }
    
    #   # count = 1
    #   poke_list = []
    #   # start = false
    #   doc.xpath('//table').css("tr").each do |val|
    #     poke_list << val.inner_text.split if val.inner_text.split[0].in?(["とくせい","隠れ特性"])
    #     break if val.inner_text.split[0] == "隠れ特性"
    #   end
    #   poke_list.each do |val|
    #     val.each do |va|
    #       if !va.in?(["とくせい","隠れ特性","※"])
    #         sp = Speciality.find_by(name: va)
    #         LearnableSpeciality.create(
    #           pokemon_id: pokemon.id,
    #           speciality_id: sp.id
    #         )
    #       end
    #     end
    #   end
    #   # doc.xpath('//table').css("tr").each do |val|
    #   #   # val.inner_text.split.pop(1)
    #   #   poke_list << [val.inner_text.split.take(val.inner_text.split.length-1)]
    #   # end
    #   # poke_list.each do |val|
    #   #   add_list << val[0].drop(1)
    #   # end
    #   # add_list.slice!(259..264)
    #   # poke_list.each_with_index do |val, i|
    #   #   add_list << [poke_list[i], poke_list[i+1]] if val[0].to_i != 0
    #   # end
    #   # return render plain: add_list
    #   # add_list.each do |val|
    #   #   Speciality.create(
    #   #     name: val[0],
    #   #     description1: val[1],
    #   #     description2: val[2] ? val[2] : nil,
    #   #     description3: val[3] ? val[3] : nil
    #   #   )
    #   # end
    #   # add_list.each do |val|
    #   #   rf = val[1][1] ? val[1][1] : nil
    #   #   poke = Pokemon.find_by(name: val[1][0], region_form: rf)
    #   #   unless poke
    #   #     errors << val[1][0] 
    #   #     next
    #   #   end
    #   #   poke.update(
    #   #     pokedex_id: val[0][0],
    #   #     region_form: rf
    #   #   )
    #   # end
    #   # type = ["変化","物理","特殊"]
    #   # result = poke_list
    #   # result = result.select {|val| val[0].to_i != 0}
    #   # result.map!{|val| val[0].to_i}

    #   # poke_status = {}
    #   # result.each do |val|
    #   #   poke_status[:h] = val[1] if val[0] == "HP"
    #   #   poke_status[:a] = val[1] if val[0] == "こうげき"
    #   #   poke_status[:b] = val[1] if val[0] == "ぼうぎょ"
    #   #   poke_status[:c] = val[1] if val[0] == "とくこう"
    #   #   poke_status[:d] = val[1] if val[0] == "とくぼう"
    #   #   poke_status[:s] = val[1] if val[0] == "すばやさ"
    #   #   if type.include?(val[3])
    #   #     poke_type = Type.find_by(name: val[2]).id
    #   #     find_type = type.index(val[3])
    #   #     accuracy = val[5].to_i
    #   #     ability = Ability.find_by(name: val[1])
    #   #     unless ability
    #   #       ability = Ability.create(
    #   #         :name => val[1], 
    #   #         :pokemon_type => poke_type, 
    #   #         :damage_type => find_type,
    #   #         :amount => val[4],
    #   #         :accuracy => accuracy,
    #   #         :min_hits => 1,
    #   #         :max_hits => 1
    #   #       )
    #   #     end
    #   #     learned_ability = LearnableAbility.find_by(ability_id: ability.id, pokemon_id: pokemon.id)
    #   #     unless learned_ability
    #   #       LearnableAbility.create(
    #   #         :ability_id => ability.id,
    #   #         :pokemon_id => pokemon.id
    #   #       )
    #   #     end
    #   #   elsif type.include?(val[2])
    #   #     poke_type = Type.find_by(name: val[1]).id
    #   #     find_type = type.index(val[2])
    #   #     accuracy = val[4].to_i
    #   #     ability = Ability.find_by(name: val[0])
    #   #     unless ability
    #   #       ability = Ability.create(
    #   #         :name => val[0], 
    #   #         :pokemon_type => poke_type, 
    #   #         :damage_type => find_type,
    #   #         :amount => val[3],
    #   #         :accuracy => accuracy,
    #   #         :min_hits => 1,
    #   #         :max_hits => 1
    #   #       )
    #   #     end
    #   #     learned_ability = LearnableAbility.find_by(ability_id: ability.id, pokemon_id: pokemon.id)
    #   #     unless learned_ability
    #   #       LearnableAbility.create(
    #   #         :ability_id => ability.id,
    #   #         :pokemon_id => pokemon.id
    #   #       )
    #   #     end
    #   #   end
    #   # end
    #   # pokemon = Pokemon.find_by(id: result)
    #   # pokemon.update(
    #   #   is_playable: true
    #   #   # h: poke_status[:h],
    #   #   # a: poke_status[:a],
    #   #   # b: poke_status[:b],
    #   #   # c: poke_status[:c],
    #   #   # d: poke_status[:d],
    #   #   # s: poke_status[:s],
    #   # )

    #   # result = poke_list[1..958]

    # end
    # # result = result.slice(0..19)
end
