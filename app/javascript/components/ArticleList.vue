<template>
  <div id="articles-container">
    <div v-for="article in articles" v-bind:key="article.id">
      <v-card class="mb-5" style="margin: 0 auto;" justify-center max-width="600" >
          <v-card-title>{{article.title}}</v-card-title>
          <v-divider class="mx-4"></v-divider>
          <v-card-text>{{article.body}}</v-card-text>
      </v-card>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data() {
    return {
      articles: []
    }
  },

  mounted() {
    this.fetchArticles();
  },

  methods: {
    async fetchArticles() {
      await axios.get("/api/v1/articles").then(response => {
        response.data.map((article) => {
          this.articles.push(article);
        });
      });
    }
  }
}
</script>
