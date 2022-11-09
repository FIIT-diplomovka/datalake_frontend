<template>
  <v-row justify="center" align="center">
    <v-col class="text-center">

      <FileUpload @uploadFileError="uploadFileError($event)" @uploadFile="uploadFile($event)"></FileUpload>
      <!-- <v-btn color="primary" nuxt to="/details_page">
      Continue
    </v-btn> -->
    </v-col>
  </v-row>
</template>

<script>
export default {
  name: 'IndexPage',
  methods: {
    // TODO: better error handling
    uploadFileError(error) {
      console.log(error)
      alert("Something went wrong, check console")
    },

    uploadFile(objectInfo) {
      this.$store.commit('new_file_upload/setBucket', objectInfo.bucket)
      this.$store.commit('new_file_upload/setObjectName',  objectInfo.name)
      console.log(this.$store.state.new_file_upload)
      this.$router.push("/new")
    }
  }
}
</script>
