<template>
    <div>
        <v-row>
            <h2>Browse data lake</h2>
        </v-row>

        <v-row v-if="isLoading">
            <v-col>
                <span>Fetching objects, please wait</span>
                <v-progress-linear indeterminate></v-progress-linear>
            </v-col>
        </v-row>

        <v-row>
            <v-card v-for="o in loaded_objects" class="mx-auto my-12" max-width="374">
                <v-card-title class="text-h4">{{ o.title }}</v-card-title>

                <v-card-text>
                    <div>{{ o.description }}</div>
                </v-card-text>

                <v-divider class="mx-4"></v-divider>

                <v-card-title class="text-h5">Tags</v-card-title>

                <v-card-text>
                    <v-slide-group>
                        <v-chip v-for="tag in o.tags" class="mx-2">{{ tag }}</v-chip>
                    </v-slide-group>
                </v-card-text>

                <v-card-actions>
                    <v-btn color="primary" nuxt :to="`/detail/${o.id}`" text @click="reserve">
                        Details
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-row>
    </div>
</template>


<script>
export default {
    name: 'FileBrowser',
    data() {
        return {
            loaded_objects: [],
            isLoading: false
        }
    },
    methods: {

    },
    async mounted() {
        this.isLoading = true
        const res = await this.$axios.get("/read/get_objects").catch(function (error) {
            console.log(error.toJSON())
            return
        })
        let res_data = res.data
        for (const [key, value] of Object.entries(res_data)) {
            this.loaded_objects.push({
                title: res_data[key]["dcm_title"],
                description: res_data[key]["dcm_description"],
                tags: res_data[key]["tags"],
                id: key
            })
        }
        this.isLoading = false
    }
}
</script>