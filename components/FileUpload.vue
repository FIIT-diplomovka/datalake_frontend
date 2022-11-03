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
            formData.append("user_file", this.file)
            formData.append("file_size", this.file.size)
            console.log(this.file.size)
            this.$axios.post("/upload", formData).catch(function (error) {
                console.log(error.toJSON())
            })
            
        }
    }

}
</script>