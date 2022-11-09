<template>
  <div>
    <v-row>
      <v-col class="text-center">
        <h1>Fill out details</h1>
      </v-col>
    </v-row>
    <v-row>
      <DublinCoreForm :object-bucket="this.$store.state.new_file_upload.bucket" :object-name="this.$store.state.new_file_upload.objectName"></DublinCoreForm>
    </v-row>
  </div>
</template>

<script>
export default {
    name: "NewFile",
    data() {
        return {
            
        }
    },
}
</script>
