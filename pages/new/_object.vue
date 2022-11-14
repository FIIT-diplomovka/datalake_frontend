<template>
  <div>
    <v-row>
      <v-col class="text-center">
        <h1>Fill out details</h1>
      </v-col>
    </v-row>
    <v-row>
      <NewEntryForm :object-bucket="this.$options.object.bucket" :object-name="this.$options.object.name"></NewEntryForm>
    </v-row>
  </div>
</template>

<script>
export default {
    name: "NewFile",
    object: { bucket: "", name: "" },
    data() {
        return {
            
        }
    },
    beforeCreate() {
      // bucket and object name come encoded as b64 string as a URL param
      this.$options.object.bucket = atob(this.$route.params.object).split("/")[0]
      this.$options.object.name = atob(this.$route.params.object).replace(`${this.$options.object.bucket}/`, '')
    },
    mounted() {
      
    }
}
</script>
