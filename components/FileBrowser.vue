<template>
    <div>
        <v-row>
            <h2>Browse data lake</h2>
        </v-row>

        <v-row>
            <v-col>
                <v-combobox small-chips clearable v-model="tagsFilter" :items="allTags" label="Select tags to filter by"
                    multiple>
                </v-combobox>
                <v-btn color="primary" @click="filter()">
                    <v-icon>
                        mdi-filter
                    </v-icon>Filter
                </v-btn>
            </v-col>
        </v-row>

        <v-row v-if="isLoading">
            <v-col>
                <span>Fetching objects, please wait</span>
                <v-progress-linear indeterminate></v-progress-linear>
            </v-col>
        </v-row>

        <v-row>
            <v-card v-for="o in loaded_objects" class="mx-auto my-12" :key="o.id" max-width="374">
                <v-card-title class="text-h4">{{ o.title }}</v-card-title>

                <v-card-text>
                    <div>{{ o.description }}</div>
                </v-card-text>

                <v-divider class="mx-4"></v-divider>

                <v-card-title class="text-h5">Tags</v-card-title>

                <v-card-text>
                    <v-slide-group>
                        <v-chip v-for="(tag, index) in o.tags" class="mx-2" :key="index">{{ tag }}</v-chip>
                    </v-slide-group>
                </v-card-text>

                <v-card-actions>
                    <v-btn color="primary" nuxt :to="`/detail/${o.id}`" outlined>
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
            isLoading: false,
            allTags: [],
            tagsFilter: []
        }
    },
    methods: {
        async filter() {
            if (this.tagsFilter.length === 0) {
                await this.$router.replace({ path: '/', query: {} }).catch(function (error) {
                    console.log(error)
                    return
                })
                this.getObjects()
                return
            }
            await this.$router.replace({ query: { tags: this.tagsFilter.join(",") } }).catch(function (error) {
                console.log(error)
                return
            })
            this.getObjects()
        },

        async getObjects() {
            this.loaded_objects = []
            this.isLoading = true
            if (await this.$route.query.tags != null && await this.$route.query.tags !== "") {
                this.tagsFilter = await this.$route.query.tags.split(",")
            }
            let tf = this.tagsFilter.length === 0 ? null : this.tagsFilter.join(",")
            const res = await this.$axios.get("/read/get_objects", { params: { tags: tf } }).catch(function (error) {
                console.log(error.toJSON())
                return
            })
            let res_data = res.data.objects
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
    },

    async created() {
        const res = await this.$axios.get("/read/get_tags").catch(function (error) {
            console.log(error.toJSON())
            return
        })
        this.allTags = res.data.tags
    },



    async mounted() {
        this.getObjects()
    }
}
</script>