require "rails_helper"

# CheatCMD
#   $ bundle exec rspec spec/requests/api/v1/articles_spec.rb --tag focus

# type: request の test をするので :requestとする
RSpec.describe "Api::V1::Articles", type: :request do
  # test対象のurl
  describe "GET /articles" do
    # status 200 の確認　
    subject { get(api_v1_articles_path) }

    context "公開記事である時" do
      # updated_at 引数設定は, descを確かめるため
      # この書き方はしない >>> let!(:article) { create_list(:article, 3) }
      # let! =>配下より先に処理される
      let!(:article1) { create(:article, :published, updated_at: 1.days.ago) }
      let!(:article2) { create(:article, :published, updated_at: 2.days.ago) }
      let!(:article3) { create(:article, :published) }

      it "記事一覧が表示できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res.length).to eq 3
        # ここは, Serializer で指定した column が入る
        expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
        expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      end
    end
  end

  describe "GET /articles/:id" do
    # 1: article_id を探す
    subject { get(api_v1_article_path(article_id)) }

    describe "正常系" do
      context "指定した id の記事が存在する場合" do
        # 3: ここの articleを辿る
        let(:article) { create(:article, :published) }
        # 2: article を探す
        let(:article_id) { article.id }

        it "指定したid の記事を表示できる" do
          subject
          res = JSON.parse(response.body)

          expect(response).to have_http_status(:ok)
          expect(res.keys).to eq ["id", "title", "body", "status", "updated_at", "user"]

          # 4: article.xx を明記
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["status"]).to eq "published"

          # be_xxx: matcher
          expect(res["updated_at"]).to be_present
        end
      end

      # context "下書き記事である場合" do
      #   let(:article) { create(:article, :draft) }
      #   let(:article_id) { article.id }

      #   fit "status 404で返す" do
      #     subject
      #     expect { subject }.to raise_error ActiveRecord::RecordNotFound
      #     # expect(response).to have_http_status(:not_found)
      #   end
      # end
    end

    describe "異常系" do
      context "指定した id の記事が存在しない場合" do
        let(:article_id) { Article.last&.id.to_i + 1 }

        it "指定したid の記事が表示できない" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe "POST /articles" do
    # 1: 定義
    #   params: article: :title, :body, :status
    #   headers: login user // token認証の値
    subject { post(api_v1_articles_path, params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let(:headers) { current_user.create_new_auth_token }

    context "login している user で記事を作成する時" do
      let(:params) { { article: attributes_for(:article) } }

      it "記事が作成できる" do
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res.keys).to eq ["id", "title", "body", "status", "updated_at", "user"]
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(res["status"]).to eq "draft"
      end
    end

    context "titleなしで、記事作成しようとする時" do
      let(:params) { { article: attributes_for(:article, title: nil) } }

      it "記事作成に失敗する" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    # 定義
    # 1.article_id: 記事No >>> params を探す
    subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

    let(:current_user) { create(:user) }
    let!(:headers) { current_user.create_new_auth_token }

    context "ログインしたuserが自身の記事を公開記事を下書きで更新しようとする時" do
      # paramsの定義 >>> articleを探す
      let(:params) { { article: attributes_for(:article, :published) } }
      let(:article) { create(:article, :draft, user: current_user) }

      it "更新できる" do
        # X を A から B に
        # expect { subject }.to change { X }.from(A).to(B)
        # subjectは1回のみしか呼べない?? >>> 1回呼び出されたら、キャッシュが効いているから
        #
        # どちらの記述も同じ値が返ってくる??　謎
        # reload: この記述にすることで 記事のデータを DB から再取得すると
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body]) &
                              change { article.reload.status }.from(article.status).to(params[:article][:status].to_s)
        expect(response).to have_http_status(:ok)
      end

      context "ログインしたuserが自身の記事を下書きから公開更新しようとする時" do
        let(:params) { { article: attributes_for(:article, :draft) } }
        let(:article) { create(:article, :published, user: current_user) }

        it "更新できる" do
          expect { subject }.to change { article.reload.status }.from(article.status).to(params[:article][:status].to_s)
          expect(response).to have_http_status(:ok)
        end
      end

      context "ログインしたuserが他人の記事を更新しようとした時" do
        # user生成
        let(:other_user) { create(:user) }
        # 先呼び出ししないとErrorする recode数の確認のところでerrorはく
        let!(:article) { create(:article, user: other_user) }

        it "更新出来ない" do
          # Error, recode数に変化ないことを確認している
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                                change { Article.count }.by(0)
        end
      end
    end
  end

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers: headers) }

    let(:current_user) { create(:user) }
    let!(:headers) { current_user.create_new_auth_token }

    let(:article_id) { article.id }

    context "ログインしたuserが自身の記事を削除しようとする時" do
      # ログインしたuserで記事作成
      let!(:article) { create(:article, user: current_user) }

      it "削除できる" do
        expect { subject }.to change { Article.count }.by(-1)
        # 204 No Content
        expect(response).to have_http_status(:no_content)
      end
    end

    context "ログインしたuserが他のuserの記事を削除しようとする時" do
      # ログインしたuserで記事作成
      let(:other_user) { create(:user) }
      # 先呼び出ししないとErrorする recode数の確認のところでerrorはく
      let!(:article) { create(:article, user: other_user) }

      it "削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end
end
