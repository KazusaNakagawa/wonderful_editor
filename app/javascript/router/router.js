import Vue from "vue";
import Router from "vue-router";
import ArticleList from "../components/ArticleList.vue";

Vue.use(Router);


const router = new Router({
  mode: "history",
  routes: [
    //ルーティングの設定
    {
      path: "/",
      component: ArticleList,
    },
  ],
});
export default router;
