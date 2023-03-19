<template>
    <v-row>
        <v-col>
            <h2>Please select a file</h2>
            <v-file-input v-model="file" show-size></v-file-input>
            <v-btn color="success" @click="uploadFile">
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
        async uploadFile(event) {
            if (this.file === null) {
                alert("Cannot be empty")
                return
            }
            let formData = new FormData()
            formData.append("user_file", this.file)
            formData.append("file_size", this.file.size)
            let res = await this.$axios.post("/write/upload", formData).catch(function (error) {
                console.log(error.toJSON())
                this.$emit("uploadFileError", error.toJSON())
                return
            })
            let object_info = res.data
            this.$emit("uploadFile", object_info)
        }
    }
}
</script>