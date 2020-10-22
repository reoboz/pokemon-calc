class CalcController < ApplicationController
  def index

    @d = Pokemon.find_by(name: params["d_pokemon_name"])
    effort = params["effort"]
    seikaku = params["seikaku"]
    item = params["item"]
    # return render plain: @d.modify_data
    # return render plain: "done"
    options = [
      :effort => effort,
      :seikaku => seikaku,
      :item => item
    ]
    @result = []
    @result = get_list(@d.id, options[0]) unless @d.nil?
    # @result = Kaminari.paginate_array(@result).page(params[:page]).per(5) unless @d.nil?
    # @result = paginate(@result,20)
    # @result = @result.slice(0..119) unless @d.nil?
    # render template: "calc/index" unless @d.nil?
  end

  # とくせい・わざ・持ち物・フィールドの処理
  def calc_1 data
    multiplied = 1

    # こうげきポケモンのとくせい処理
    num = 4096
    case data[:a_pokemon][:speciality] # TODO: 技のタイプが変わったとき戻せない
    # when "オーラブレイク","とうそうしん"
    when "エレキスキン"
      num = 4915 if data[:ability].pokemon_type == 1
      data[:ability].pokemon_type == 4
    when "スカイスキン"
      num = 4915 if data[:ability].pokemon_type == 1
      data[:ability].pokemon_type == 10
    when "ノーマルスキン"
      num = 4915
      data[:ability].pokemon_type == 1
    when "フェアリースキン"
      num = 4915 if data[:ability].pokemon_type == 1
      data[:ability].pokemon_type == 18
    when "フリーズスキン"
      num = 4915 if data[:ability].pokemon_type == 1
      data[:ability].pokemon_type == 6
    when "てつのこぶし"
      punches = [
        "れんぞくパンチ",
        "メガトンパンチ",
        "ほのおのパンチ",
        "れいとうパンチ",
        "かみなりパンチ",
        "ピヨピヨパンチ",
        "マッハパンチ",
        "ばくれつパンチ",
        "きあいパンチ",
        "コメットパンチ",
        "シャドーパンチ",
        "スカイアッパー",
        "アームハンマー",
        "バレットパンチ",
        "ドレインパンチ",
        "アイスハンマー"
      ]
      num = 4915 if data[:ability].name.in?(punches)
    when "すてみ"
      sutemi = [
        "すてみタックル",
        "ウッドハンマー",
        "ブレイブバード",
        "とっしん",
        "じごくぐるま",
        "ボルテッカー",
        "フレアドライブ",
        "もろはのずつき",
        "とびげり",
        "とびひざげり",
        "アフロブレイク",
        "ワイルドボルト"
      ]
      num = 4915 if data[:ability].name.in?(sutemi)
    # when "とうそうしん(強化)" 
    # when "バッテリー" 
    # when "ちからずく"
      num = 5325
    when "すなのちから"
      target_type = [
        "いわ",
        "じめん",
        "はがね"
      ]
      num = 5325 if data[:ability].pokemon_type.in?(target_type)
    when "アナライズ"
      num = 5325
    when "かたいツメ" # TODO: 接触・非接触技カラムをabilitiesに追加し場合分け
      num = 5325
    when "パンクロック"
      sounds = [
        "いびき",
        "うたかたのアリア",
        "エコーボイス",
        "さわぐ",
        "スケイルノイズ",
        "バークアウト",
        "ハイパーボイス",
        "ばくおんば",
        "むしのさざめき",
        "りんしょう"
      ]
      num = 5325 if data[:ability].name.in?(sounds)
    # when "パワースポット"
    when "フェアリーオーラ"
      num = 5448 if data[:ability].pokemon_type == 18
      num = 3072 if data[:d_pokemon][:speciality] == "オーラブレイク"
    when "ダークオーラ"
      num = 5448 if data[:ability].pokemon_type == 16
      num = 3072 if data[:d_pokemon][:speciality] == "オーラブレイク"
    when "テクニシャン"
      num = 6144 if data[:ability].amount <= 60
    when "ねつぼうそう" # TODO: やけどフラグを確認する
      num = 6144 if data[:ability].damage_type == 2
    when "どくぼうそう" # TODO: どく,もうどくフラグを確認する
      num = 6144 if data[:ability].damage_type == 1
    when "がんじょうあご"
      kiba = [
        "かみつく",
        "かみくだく",
        "どくどくのキバ",
        "ほのおのキバ",
        "かみなりのキバ",
        "こおりのキバ",
        "ひっさつまえば",
        "サイコファング",
        "エラがみ"
      ]
      num = 6144 if data[:ability].name.in?(kiba)
    when "メガランチャー"
      hadou = [
        "りゅうのはどう",
        "みずのはどう",
        "あくのはどう",
        "いやしのはどう",
        "はどうだん",
        "こんげんのはどう"
      ]
      num = 6144 if data[:ability].name.in?(hadou)
    when "はがねのせいしん"
      num = 6144 if data[:ability].pokemon_type == 17
    when "かたやぶり" # TODO: 無視できない技を対象外にする
      data[:d_pokemon][:speciality] = "無効化"
    else 
    end
    multiplied *= (num / 4096.to_f)
    
    # ぼうぎょポケモンのとくせい処理
    num = 4096
    case data[:d_pokemon][:speciality]
    # when "オーラブレイク" フェアリーオーラ、ダークオーラに書いてある
    when "たいねつ"
      num = 2048 if data[:ability].pokemon_type == 2
    when "かんそうはだ"
      num = 5120 if data[:ability].pokemon_type == 2
    else
    end
    multiplied *= (num / 4096.to_f)

    # こうげきポケモンのもちもの処理 TODO: フォームで10～50％でブーストにしてもいいかも
    # こうげきポケモンのわざ処理
    num = 4096
    case data[:ability]
    when "ソーラービーム", "ソーラーブレード"
      bad_weather = [
        "あめ",
        "おおあめ",
        "すなあらし",
        "あられ"
      ]
      num = 2048 if data[:weather].in?(bad_weather)
    when "さきどり" # TODO:?
      num = 6144
    when "はたきおとす" #TODO:?
      num = 6144
    when "Gのちから" #TODO:?
      # num = 6144 if data[:field].include?("じゅうりょく")
    when "からげんき" #TODO:?
      num = 8192
    # when "しおみず"
    when "ベノムショック" #TODO:?
      num = 8192
    when "かたきうち"
      num = 8192
    else
    end
    multiplied *= (num / 4096.to_f)

    # フィールド処理
    num = 4096
    case data[:field]
    when "エレキフィールド"
      unless data[:a_pokemon].types.include?(10) \
        || data[:a_pokemon][:speciality] == "ふゆう"
        if data[:ability].pokemon_type == 4
          num = 5325
        end
      end
    when "グラスフィールド"
      unless data[:a_pokemon].types.include?(10) \
        || data[:a_pokemon][:speciality] == "ふゆう"
        if data[:ability].pokemon_type == 5
          num = 5325
        elsif data[:ability].name.in?(["じしん","じならし","マグニチュード"])
          num = 2048
        end
      end
    when "ミストフィールド"
      unless data[:a_pokemon].types.include?(10) \
        || data[:a_pokemon][:speciality] == "ふゆう"
        if data[:ability].pokemon_type == 15
          num = 2048
        end
      end
    when "サイコフィールド" #TODO:? ゆうせんど高い技の無効化？
      unless data[:a_pokemon].types.include?(10) \
        || data[:a_pokemon][:speciality] == "ふゆう"
        if data[:ability].pokemon_type == 11
          num = 5325
        end
      end
    else 
    end
    multiplied *= (num / 4096.to_f)

    data[:multiplied] = multiplied
    # puts "1:#{data[:multiplied]}" if multiplied != 1
    
    return data
  end

  def calc_2 data #TODO: ダメージ計算の / 4096が意味分からん
    # 威力変化わざ処理
    case data[:ability]
    # when "アクロバット"
      # data[:ability].amount *= 2 if data
    when "エラがみ", "でんげきくちばし"
      data[:ability].amount *= 2
    end

    result = (data[:ability].amount * data[:multiplied]).to_f
    if data[:multiplied] == 1
      if result - result.to_i > 0.5
        result = result.ceil
      elsif result - result.to_i <= 0.5
        result = result.floor
      end
    else
      result = result.round
    end

    result = 1 if result < 1
    
    data[:result_1] = result
    # puts "2:#{result}"
    return data
  end

  def calc_3 data
    multiplied = 1

    # こうげきポケモンのとくせい処理
    num = 4096
    case data[:a_pokemon][:speciality] # TODO: 複数とくせいを持ってる場合ダメージの高いものを優先する
    # when "スロースタート"
    # when "よわき"
    when "フラワーギフト"
      num = 6144 if data[:weather] = "にほんばれ" && data[:ability].damage_type == 1
    when "こんじょう" #TODO:?
      num = 6144 if data[:ability].damage_type == 1
    when "しんりょく" #TODO: only for low
      num = 6144 if data[:ability].pokemon_type == 5
    when "もうか"
      num = 6144 if data[:ability].pokemon_type == 2
    when "げきりゅう"
      num = 6144 if data[:ability].pokemon_type == 3
    when "むしのしらせ"
      num = 6144 if data[:ability].pokemon_type == 12
    # when "もらいび"
    when "サンパワー"
      num = 6144 if data[:weather] = "にほんばれ" && data[:ability].damage_type == 2
    when "はがねつかい"
      num = 6144 if data[:ability].pokemon_type == 17
    when "ごりむちゅう"
      num = 6144 if data[:ability].damage_type == 1
    when "ちからもち", "ヨガパワー"
      num = 8192 if data[:ability].damage_type == 1
    when "すいほう"
      num = 8192 if data[:ability].pokemon_type = 3
    # when "はりこみ"
    end
    multiplied *= (num / 4096.to_f)

    # ぼうぎょポケモンのとくせい処理
    num = 4096
    case data[:d_pokemon][:speciality]
    when "あついしぼう"
      num = 2048 if data[:ability].damage_type.in?([2,6])
    when "すいほう"
      num = 2048 if data[:ability].damage_type == 3
    end
    multiplied *= (num / 4096.to_f)

    data[:multiplied] = multiplied

    # puts "3:#{data[:multiplied]}" if multiplied != 1
    return data
  end
  def calc_4 data
    rank = [
      2/8.to_f,
      2/7.to_f,
      2/6.to_f,
      2/5.to_f,
      2/4.to_f,
      2/3.to_f,
      2/2.to_f,
      3/2.to_f,
      4/2.to_f,
      5/2.to_f,
      6/2.to_f,
      7/2.to_f,
      8/2.to_f
    ]
    amount = data[:a_pokemon][:a] if data[:ability].damage_type == 1
    amount = data[:a_pokemon][:c] if data[:ability].damage_type == 2
    amount *= 1.5.floor if data[:a_pokemon][:speciality] == "はりきり"

    result = amount

    if data[:multiplied] == 1
      if result - result.to_i > 0.5
        result = result.ceil
      elsif result - result.to_i <= 0.5
        result = result.floor
      end
    else
      result = result.round
    end

    result = 1 if result < 1
    
    data[:result_2] = result
    # puts "4:#{result}"

    return data

  end
  def calc_5 data
    multiplied = 1

    # ぼうぎょポケモンのとくせい処理
    num = 4096
    case data[:speciality]
    when "フラワーギフト"
      num = 6144 if data[:weather] == "にほんばれ"
    when "ふしぎなうろこ" #TODO:? 状態異常のとき
      num = 6144
    when "くさのけがわ"
      num = 6144 if data[:field] == "グラスフィールド"
    when "ファーコート"
      num = 8192 if data[:ability].damage_type == 1
    else
    end
    multiplied *= (num / 4096.to_f)

    # ぼうぎょポケモンのもちもの処理
    num = 4096
    case data[:d_pokemon][:item]
    when "しんかのきせき"
      num = 6144
    when "とつげきチョッキ"
      num = 6144 if data[:ability].damage_type == 2
    else
    end
    multiplied *= (num / 4096.to_f)

    data[:multiplied] = multiplied
    # puts "5:#{data[:multiplied]}" if multiplied != 1
    return data
  end

  def calc_6 data
    rank = [
      2/8.to_f,
      2/7.to_f,
      2/6.to_f,
      2/5.to_f,
      2/4.to_f,
      2/3.to_f,
      2/2.to_f,
      3/2.to_f,
      4/2.to_f,
      5/2.to_f,
      6/2.to_f,
      7/2.to_f,
      8/2.to_f
    ]
    amount = data[:d_pokemon][:b] if data[:ability].damage_type == 1
    amount = data[:d_pokemon][:d] if data[:ability].damage_type == 2
    amount *= 1.5.floor if data[:d_pokemon][:type].include?(13) && data[:weather] == "すなあらし"

    result = amount

    if data[:multiplied] == 1
      if result - result.to_i > 0.5
        result = result.ceil
      elsif result - result.to_i <= 0.5
        result = result.floor
      end
    else
      result = result.round
    end

    result = 1 if result < 1
    
    data[:result_3] = result
    # puts "6:#{result}"

    return data
  end
  def calc_7 data

    multiplied = 1

    # 壁処理
    num = 4096
    case data[:wall]
    when "ひかりのかべ"
      num = 2048 
    when "リフレクター"
      num = 2048
    when "オーロラベール"
      num = 2048
    end
    multiplied *= (num / 4096.to_f)

    # こうげきポケモンのとくせい処理
    # num = 4096
    # case data[:a_pokemon][:speciality]
    # when "ブレインフォース"
    # when "スナイパー"
    # when "いろめがね"
    # end
    # multiplied *= (num / 4096.to_f)

    # ぼうぎょポケモンのとくせい処理
    num = 4096
    case data[:speciality]
    when "マルチスケイル", "ファントムガード"
      num = 2048
    when "もふもふ"
      num /= 2 if data[:ability].damage_type == 1
      num *= 2 if data[:ability].pokemon_type == 2
    when "パンクロック"
      sounds = [
        "いびき",
        "うたかたのアリア",
        "エコーボイス",
        "さわぐ",
        "スケイルノイズ",
        "バークアウト",
        "ハイパーボイス",
        "ばくおんば",
        "むしのさざめき",
        "りんしょう"
      ]
      num = 2048 if data[:ability].name.in?(sounds)
    when "こおりのりんぷん"
      num = 2048 if data[:ability].damage_type == 2
    # when "ハードロック", "フィルター", "プリズムアーマー"
    else
    end
    multiplied *= (num / 4096.to_f)

    multiplied *= (2048 / 4096.to_f) if data[:d_pokemon][:item] == "半減きのみ"
    # こうげきぽけもんの持ち物、やらない？
    # こうげきポケモンのわざ処理 TODO:

    data[:multiplied] = multiplied
    # puts "7:#{data[:multiplied]} if multiplied != 1" if multiplied != 1
    return data
    
  end

  def calc_8 data
    result = {
      :damage => [],
    }
    attack_rate = 22
    random = [0.85,0.86,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,1.00]

    damage = (attack_rate * data[:result_1] * data[:result_2] / data[:result_3].to_f).floor
    damage = (damage / 50.to_f).floor
    damage = (damage + 2).floor
    random.each do |val|
      result[:damage] << (damage * val).floor
    end
    result[:speciality] = data[:a_pokemon][:speciality]
    result[:poke_a] = data[:a_pokemon][:a]
    result[:poke_c] = data[:a_pokemon][:c]
    # if おやこあい todo
    # if 天気弱化・強化 todo
    # if きゅうしょ todo

    # タイプ一致ボーナス
    if data[:ability].pokemon_type.in?([data[:a_pokemon][:type]])
      result[:damage].map!{|damage|
        multiplied = 6144
        multiplied = 8192 if data[:a_pokemon][:speciality] == "てきおうりょく"
        damage = (damage * multiplied / 4096.to_f)
        if damage - damage.to_i > 0.5
          damage = damage.ceil
        elsif damage - damage.to_i <= 0.5
          damage = damage.floor
        end
      }
    end

    result[:damage].map!{|damage|
      # タイプ相性ボーナス
      multiplied = 1
      multiplied = calc_pokemon_type(data[:ability], data[:d_pokemon])
      damage *= multiplied
      # calc_7の計算
      damage = (damage * data[:multiplied].to_f)
      if damage - damage.to_i > 0.5
        damage = damage.ceil
      elsif damage - damage.to_i <= 0.5
        damage = damage.floor
      end
      
      # damage = 1 if damage == 0
    }


    return result

  end
  # 攻撃ポケモンのステータス実数値取得・計算
  def get_a_pokemon a_pokemon

    shuzoku_a = a_pokemon.a
    shuzoku_c = a_pokemon.c

    result_a = 
    ((shuzoku_a*2 + 31 + (252 /4).floor) * 50.floor / 100.floor + 5)

    result_c = 
    ((shuzoku_c*2 + 31 + (252 /4).floor) * 50.floor / 100.floor + 5)

    result_a = (result_a * 1.1.to_f).floor
    result_c = (result_c * 1.1.to_f).floor


    a_pokemon_status = {
      :id => a_pokemon.id,
      :type => [],
      :a => result_a,
      :c => result_c,
    }
    a_pokemon_status[:type] << a_pokemon.type1 if a_pokemon.type1
    a_pokemon_status[:type] << a_pokemon.type2 if a_pokemon.type2
    a_pokemon_status[:specialities] = a_pokemon.specialities.present? ? a_pokemon.specialities.pluck(:name) : ["なし"]

    return a_pokemon_status
  end
  # 防御ポケモンのステータス実数値取得・計算
  def get_d_pokemon d_pokemon_id, options
    d_pokemon = Pokemon.find_by(id: d_pokemon_id)

    shuzoku_h = d_pokemon.h
    shuzoku_b = d_pokemon.b
    shuzoku_d = d_pokemon.d

    if options[:effort] == "none"
      effort_h = 0
      effort_b = 0
      effort_d = 0
    elsif options[:effort] == "h"
      effort_h = 252
      effort_b = 0
      effort_d = 0
    elsif options[:effort] == "hb"
      effort_h = 252
      effort_b = 252
      effort_d = 0
    elsif options[:effort] == "hd"
      effort_h = 252
      effort_b = 0
      effort_d = 252
    end

    speciality = options ? options['speciality'] : "なし"

    result_h = 
    (shuzoku_h*2 + 31 + (effort_h /4).floor) * 50.floor / 100.floor + 60

    result_b = 
    ((shuzoku_b*2 + 31 + (effort_b /4).floor) * 50.floor / 100.floor + 5)

    result_d = 
    ((shuzoku_d*2 + 31 + (effort_d /4).floor) * 50.floor / 100.floor + 5)

    result_b = (result_b * 1.1.to_f).floor if options[:seikaku] == 1
    result_d = (result_d * 1.1.to_f).floor if options[:seikaku] == 2
    result_b = (result_b * 0.9.to_f).floor if options[:seikaku] == 3
    result_d = (result_d * 0.9.to_f).floor if options[:seikaku] == 4
    
    case options[:item]
    when "0"
      options[:item] = "なし"
    when "1"
      options[:item] = "半減きのみ"
    when "2"
      options[:item] = "とつげきチョッキ"
    when "3"
      options[:item] = "しんかのきせき"
    end

    d_pokemon_status = {
      :id => d_pokemon.id,
      :type => [],
      :h => result_h,
      :b => result_b, 
      :d => result_d,
      :speciality => speciality,
      :item => options[:item]
    }
    d_pokemon_status[:type] << d_pokemon.type1 if d_pokemon.type1
    d_pokemon_status[:type] << d_pokemon.type2 if d_pokemon.type2

    return d_pokemon_status
  end

  # 攻撃の実ダメージ取得
  def get_damage a_pokemon, ability, d_pokemon
    attack_rate = 22
    damages = nil
    sim_data = {
      :a_pokemon => a_pokemon,
      :ability => ability,
      :d_pokemon => d_pokemon,
    }
    compare_best_speciality = []
    
    sim_data[:a_pokemon][:specialities].each do |speciality|
      sim_data[:a_pokemon][:speciality] = speciality
      sim_data = calc_1(sim_data)
      sim_data = calc_2(sim_data)
      sim_data = calc_3(sim_data)
      sim_data = calc_4(sim_data)
      sim_data = calc_5(sim_data)
      sim_data = calc_6(sim_data)
      sim_data = calc_7(sim_data)
      damages = calc_8(sim_data)
      
      compare_best_speciality << damages
    end
    compare_best_speciality.sort_by!{|a| a[:damage]}.reverse!
    result = compare_best_speciality[0]
    return result

  end

  def get_list d_pokemon_id, prefs
    damage_ranking = []
    d_pokemon_status = get_d_pokemon(d_pokemon_id, prefs)
    a_pokemons = Pokemon.all.preload(:abilities, :specialities)
    a_pokemons.each do |a_pokemon|
      a_pokemon_status = get_a_pokemon(a_pokemon)
      a_pokemon.abilities.each do|ability|
        # next unless ability.name == "じしん"
        result = get_damage(a_pokemon_status, ability, d_pokemon_status)
        list_element = { 
          :pokemon => a_pokemon.name, 
          :poke_a => result[:poke_a],
          :poke_c => result[:poke_c],
          :ability => ability.name, 
          :damage => result[:damage],
          :speciality => result[:speciality]
        }
        damage_ranking << list_element
      end
    end
    damage_ranking.sort_by! {|a| a[:damage]}.reverse!

    damage_ranking.map do|attempt|
      if attempt[:damage].first > 0
        attempt[:ideal_hits_needed] = (d_pokemon_status[:h] / attempt[:damage].last.to_f).ceil
        attempt[:ideal_permille] = "#{((attempt[:damage].last / d_pokemon_status[:h].to_f)*100).round(1)}%"
        attempt[:worst_hits_needed] = (d_pokemon_status[:h] / attempt[:damage].first.to_f).ceil
        attempt[:worst_permille] = "#{((attempt[:damage].first / d_pokemon_status[:h].to_f)*100).round(1)}%"
      end
      if attempt[:worst_hits_needed] == 1
        attempt[:hits] = "確１"
      elsif attempt[:ideal_hits_needed] == 1
        attempt[:hits] = "乱１"
      elsif attempt[:worst_hits_needed] == 2
        attempt[:hits] = "確２"
      elsif attempt[:ideal_hits_needed] == 2
        attempt[:hits] = "乱２"
      else
        attempt[:hits] = "強敵"
      end
    end
    return damage_ranking
  end

  def calc_pokemon_type(ability, d_pokemon)
    attack_rate = 1
    attack_type = ability.pokemon_type
    defend_type = d_pokemon[:type] 

    defend_type.each do|type|
      case attack_type
      when 1 then
        # ノーマル
        damage_multiplied =
        [0,1,1,1,1,1,1,1,1,1,1,1,1,0.5,0,1,1,0.5,1]
        attack_rate *= damage_multiplied[type]
      when 2 then
        # ほのお
        damage_multiplied =
        [0,0,0.5,0.5,1,2,2,1,1,1,1,1,2,0.5,1,0.5,1,2,1]
        attack_rate *= damage_multiplied[type]
      when 3 then
        # みず
        damage_multiplied =
        [0,1,2,0.5,1,0.5,1,1,1,2,1,1,1,2,1,0.5,1,1,1]
        attack_rate *= damage_multiplied[type]
      when 4 then
        damage_multiplied =
        [0,1,1,2,0.5,0.5,1,1,1,0,2,1,1,1,1,0.5,1,1,1]
        attack_rate *= damage_multiplied[type]
      when 5 then
        damage_multiplied =
        [0,1,0.5,2,1,0.5,1,1,0.5,2,0.5,1,0.5,2,1,0.5,1,0.5,1]
        attack_rate *= damage_multiplied[type]
      when 6 then
        damage_multiplied =
        [0,1,0.5,0.5,1,2,0.5,1,1,2,2,1,1,1,1,2,1,0.5,1]
        attack_rate *= damage_multiplied[type]
      when 7 then
        damage_multiplied =
        [0,2,1,1,1,1,2,1,0.5,1,0.5,0.5,0.5,2,0,1,2,2,0.5]
        attack_rate *= damage_multiplied[type]
      when 8 then
        damage_multiplied =
        [0,1,1,1,1,2,1,1,0.5,0.5,1,1,1,0.5,0.5,1,1,0,2]
        attack_rate *= damage_multiplied[type]
      when 9 then
        damage_multiplied =
        [0,1,2,1,2,0.5,1,1,2,1,0,1,0.5,2,1,1,1,2,1]
        attack_rate *= damage_multiplied[type]
      when 10 then
        # ひこう
        damage_multiplied =
        [0,1,1,1,0.5,2,1,2,1,1,1,1,2,0.5,1,1,1,0.5,1]
        attack_rate *= damage_multiplied[type]
      when 11 then
        damage_multiplied =
        [0,1,1,1,1,1,1,2,2,1,1,0.5,1,1,1,1,0,0.5,1]
        attack_rate *= damage_multiplied[type]
      when 12 then
        damage_multiplied =
        [0,1,0.5,1,1,2,1,0.5,0.5,1,0.5,2,1,1,0.5,1,2,0.5,0.5]
        attack_rate *= damage_multiplied[type]
      when 13 then
        damage_multiplied =
        [0,1,2,1,1,1,2,0.5,1,0.5,2,1,2,1,1,1,1,0.5,1]
        attack_rate *= damage_multiplied[type]
      when 14 then
        damage_multiplied =
        [0,0,1,1,1,1,1,1,1,1,1,2,1,1,2,1,0.5,1,1]
        attack_rate *= damage_multiplied[type]
      when 15 then
        damage_multiplied =
        [0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,0.5,0]
        attack_rate *= damage_multiplied[type]
      when 16 then
        damage_multiplied =
        [0,1,1,1,1,1,1,0.5,1,1,1,2,1,1,2,1,0.5,1,0.5]
        attack_rate *= damage_multiplied[type]
      when 17 then
        damage_multiplied =
        [0,1,0.5,0.5,0.5,1,2,1,1,1,1,1,1,2,1,1,1,0.5,2]
        attack_rate *= damage_multiplied[type]
      when 18 then
        damage_multiplied =
        [0,1,0.5,1,1,1,1,2,0.5,1,1,1,1,1,1,2,2,0.5,1]
        attack_rate *= damage_multiplied[type]
      end
    end
    return attack_rate
  end
end
