class Pokemon < ApplicationRecord
  default_scope -> {where(pokedex_id: 1..Float::INFINITY)}
  has_many :learnable_abilities
  has_many :abilities, through: :learnable_abilities
  has_many :learnable_specialities
  has_many :specialities, through: :learnable_specialities
  has_one :evolve_to, class_name: 'Pokemon'
  has_one :evolved_from, class_name: 'Pokemon'
  
# スクレイピング時の残り
  def modify_data
    require 'open-uri'
    require 'uri'
    
    charset = 'utf-8'

    html = open("https://wiki.xn--rckteqa2e.com/wiki/%E3%82%B2%E3%83%B3%E3%82%AC%E3%83%BC") { |f| f.read }
    doc = Nokogiri::HTML.parse(html, nil, charset)
    poke_list = []
    # <br>タグを改行（\n）に変えて置くとスクレイピングしやすくなる。
    doc.search('br').each { |n| n.replace("\n") }

    doc.xpath('//table[@class="bluetable"]').each do |val|
      # val.inner_text.split.pop(1)
      poke_list << [val.split]
    end
    return poke_list
    
    # poke_status = {}
    # result.each do |val|
    #   poke_status[:h] = val[1] if val[0] == "HP"
    #   poke_status[:a] = val[1] if val[0] == "こうげき"
    #   poke_status[:b] = val[1] if val[0] == "ぼうぎょ"
    #   poke_status[:c] = val[1] if val[0] == "とくこう"
    #   poke_status[:d] = val[1] if val[0] == "とくぼう"
    #   poke_status[:s] = val[1] if val[0] == "すばやさ"
    #   if type.include?(val[3])
    #     poke_type = Type.find_by(name: val[2]).id
    #     find_type = type.index(val[3])
    #     accuracy = val[5].to_i
    #     ability = Ability.find_by(name: val[1])
    #     unless ability
    #       ability = Ability.create(
    #         :name => val[1], 
    #         :pokemon_type => poke_type, 
    #         :damage_type => find_type,
    #         :amount => val[4],
    #         :accuracy => accuracy,
    #         :min_hits => 1,
    #         :max_hits => 1
    #       )
    #     end
    #   end
    # end
  end
end
