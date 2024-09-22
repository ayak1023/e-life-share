# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

olivia = User.find_or_create_by!(email: "olivia@example.com") do |user|
  user.name = "Olivia"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.png"), filename:"sample-user1.png")
end

james = User.find_or_create_by!(email: "james@example.com") do |user|
  user.name = "James"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.png"), filename:"sample-user2.png")
  user.introduction = "みなさまのお役に立てる情報を発信していきます！"
end

lucas = User.find_or_create_by!(email: "lucas@example.com") do |user|
  user.name = "Lucas"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.png"), filename:"sample-user3.png")
end

emma = User.find_or_create_by!(email: "emma@example.com") do |user|
  user.name = "Emma"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user4.png"), filename:"sample-user4.png")
  user.introduction = "より良い人生のために少しでも生活の質をあげたい！"
end

noah = User.find_or_create_by!(email: "noah@example.com") do |user|
  user.name = "Noah"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user5.png"), filename:"sample-user5.png")
  user.introduction = "趣味は旅行と読書です。"
end

test_category = Category.find_or_create_by!(name: "テスト")
job_category = Category.find_or_create_by!(name: "仕事")
home_category = Category.find_or_create_by!(name: "家事")
health_category = Category.find_or_create_by!(name: "健康")
study_category = Category.find_or_create_by!(name: "勉強")


post1 = Post.find_or_create_by!(title: "早起きしやすくする方法") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.png"), filename:"sample-post1.png")
  post.body = "起きる時間は徐々に早くしていき、1週間は続ける。寝る1時間前にはスマホから離れる。寝る3時間前に夕食は済ませておく。7時間は寝る。"
  post.user = olivia
  post.created_at = Time.zone.parse("2024-09-01 10:01:00")
  post.categories << test_category
  post.categories << health_category
end

post2 = Post.find_or_create_by!(title: "1年使わなかったものは手放す") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.png"), filename:"sample-post2.png")
  post.body = "快適な暮らしのために断捨離は必須です。１年間使わなかったものは、次の１年間も大体使わないので、潔く捨てましょう。"
  post.user = james
  post.created_at = Time.zone.parse("2024-09-12 16:42:00")
  post.categories << test_category
  post.categories << home_category
end

post3 = Post.find_or_create_by!(title: "排水溝のぬめり対策") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.png"), filename:"sample-post3.png")
  post.body = '排水溝のぬめりは丸めたアルミホイルを数個入れるだけで抑えられます。'
  post.user = lucas
  post.created_at = Time.zone.parse("2024-09-15 09:31:00")
  post.categories << test_category
  post.categories << home_category
end

post4 = Post.find_or_create_by!(title: "生活リズムの整え方") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post4.png"), filename:"sample-post4.png")
  post.body = "生活リズムを整えるには、毎日同じ時間に寝起きすることが重要です。特に、寝る前はリラックスできる環境を作ることが大切です。"
  post.user = olivia
  post.created_at = Time.zone.parse("2024-09-20 22:16:00")
  post.categories << test_category
  post.categories << health_category
end

post5 = Post.find_or_create_by!(title: "スキルアップのための勉強法") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post5.png"), filename:"sample-post5.png")
  post.body = "スキルアップには、目標を明確にし、計画的に学習を進めることが重要です。定期的に振り返りを行い、成果を確認しましょう。"
  post.user = noah
  post.created_at = Time.zone.parse("2024-09-22 06:16:00")
  post.categories << test_category
  post.categories << study_category
  post.categories << job_category
end

post6 = Post.find_or_create_by!(title: "ストレス管理の方法") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post6.png"), filename:"sample-post6.png")
  post.body = "ストレスを管理するには、自分に合ったリラックス法を見つけることが重要です。運動や趣味、友人との時間を大切にしましょう。"
  post.user = lucas
  post.created_at = Time.zone.parse("2024-09-22 09:59:00")
  post.categories << test_category
  post.categories << health_category
end

post7 = Post.find_or_create_by!(title: "仕事の生産性向上") do |post|
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post7.png"), filename:"sample-post7.png")
  post.body = "生産性を上げるには、タスクの可視化とデッドラインの設定が効果的です。また、効率的なツールを活用し、集中できる時間を確保しましょう。"
  post.user = james
  post.created_at = Time.zone.parse("2024-09-22 19:08:00")
  post.categories << test_category
end


Comment.find_or_create_by!(body: "この方法を真似してみたいと思います！") do |comment|
  comment.user = lucas
  comment.post = post1
end

Comment.find_or_create_by!(body: "物が捨てられない性格だったんですが、こういった基準で断捨離をやってみたら、案外必要ではないものがたくさんあり、断捨離できました！") do |comment|
  comment.user = emma
  comment.post = post2
end

Comment.find_or_create_by!(body: "これはとても効果がありました！") do |comment|
  comment.user = olivia
  comment.post = post3
end

Comment.find_or_create_by!(body: "アルミホイルは大きめに丸めるといいですよ。") do |comment|
  comment.user = james
  comment.post = post3
end

Comment.find_or_create_by!(body: "アルミホイルは大きめに丸めるといいですよ。") do |comment|
  comment.user = james
  comment.post = post3
end

Comment.find_or_create_by!(body: "寝る前のスマホ時間はやめて、同じ時間に寝ることをまずは意識します！") do |comment|
  comment.user = noah
  comment.post = post4
end

Comment.find_or_create_by!(body: "風呂は寝る一時間以上前に入る方がいいみたいですね。") do |comment|
  comment.user = james
  comment.post = post4
end

Comment.find_or_create_by!(body: "自分に合ったリラックス方法、いろいろ試してみます！") do |comment|
  comment.user = emma
  comment.post = post6
end

Comment.find_or_create_by!(body: "自分に合ったリラックス方法、いろいろ試してみます！") do |comment|
  comment.user = emma
  comment.post = post6
end


Favorite.find_or_create_by!(user: emma, post: post1)
Favorite.find_or_create_by!(user: james, post: post1)
Favorite.find_or_create_by!(user: lucas, post: post1)
Favorite.find_or_create_by!(user: noah, post: post1)
Favorite.find_or_create_by!(user: emma, post: post2)
Favorite.find_or_create_by!(user: lucas, post: post3)
Favorite.find_or_create_by!(user: lucas, post: post3)
Favorite.find_or_create_by!(user: noah, post: post4)
Favorite.find_or_create_by!(user: noah, post: post7)
Favorite.find_or_create_by!(user: olivia, post: post4)

Relationship.find_or_create_by!(follower: olivia, followed: james)
Relationship.find_or_create_by!(follower: olivia, followed: lucas)
Relationship.find_or_create_by!(follower: olivia, followed: emma)
Relationship.find_or_create_by!(follower: james, followed: olivia)
Relationship.find_or_create_by!(follower: james, followed: lucas)
Relationship.find_or_create_by!(follower: lucas, followed: james)
Relationship.find_or_create_by!(follower: lucas, followed: noah)
Relationship.find_or_create_by!(follower: noah, followed: james)
Relationship.find_or_create_by!(follower: emma, followed: olivia)
Relationship.find_or_create_by!(follower: emma, followed: james)

puts "seedの実行が完了しました"

