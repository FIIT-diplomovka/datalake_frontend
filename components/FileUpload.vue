<template>
    <v-row>
        <v-col>
            <h2>Please select a file</h2>
            <v-file-input v-model="file" show-size></v-file-input>
            <v-btn color="primary" @click="uploadFile">
                Upload to data lake
            </v-btn>
        </v-col>
    </v-row>
</template>

<script>
export default {
    name: 'FileUpload',
    data() {
        return {
            file: null,
        }
    },
    methods: {
        uploadFile(event) {
            if (this.file === null) {
                alert("Cannot be empty")
            }
            let formData = new FormData()
            formData.append("file", this.file)
            this.$axios.post("/upload", formData)
            
        }
    }

}
</script>