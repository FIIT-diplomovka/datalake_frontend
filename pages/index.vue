<template>
  <v-container>
    <v-row justify="center" align="center">
      <v-col class="text-right">
        <v-btn color="primary" nuxt to="/upload">
          Upload to datalake
        </v-btn>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <FileBrowser></FileBrowser>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: 'IndexPage',
  methods: {
  }
}
</script>
