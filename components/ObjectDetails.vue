<template>
    <div>
        <v-row>
            <h2>Object details</h2>
        </v-row>
        <br>
        <br>
        <v-row v-if="isLoading">
            <v-col>
                <span>Fetching details, please wait</span>
                <v-progress-linear indeterminate></v-progress-linear>
            </v-col>
        </v-row>

        <v-row>
            <v-container>
                <v-row>
                    <h3>Dublin core metadata</h3>
                </v-row>
                <v-row>
                    <p class="mr-10"><b>Title:</b> {{ current_object.dublin_core.title.value }}</p>

                    <p class="mr-10"><b>Creator:</b> {{ current_object.dublin_core.creator.value }}</p>
                </v-row>
                <v-row>
                    <p class="mr-10"><b>Publisher:</b> {{ current_object.dublin_core.publisher.value }}</p>

                    <p class="mr-10"><b>Contributor:</b> {{ current_object.dublin_core.contributor.value }}</p>
                </v-row>
                <v-row>
                    <p class="mr-10"><b>Coverage:</b> {{ current_object.dublin_core.coverage.value }}</p>

                    <p class="mr-10"><b>Subject:</b> {{ current_object.dublin_core.subject.value }}</p>
                </v-row>
                <v-row>
                    <p class="mr-10"><b>Date:</b> {{ current_object.dublin_core.date.value }}</p>

                    <p class="mr-10"><b>Language:</b> {{ current_object.dublin_core.language.value }}</p>
                </v-row>
                <v-row>
                    <p class="mr-10"><b>Format:</b> {{ current_object.dublin_core.format.value }}</p>

                    <p class="mr-10"><b>Type:</b> {{ current_object.dublin_core.type.value }}</p>
                </v-row>
                <v-row>
                    <p class="mr-10"><b>identifier:</b> {{ current_object.dublin_core.identifier.value }}</p>

                    <p class="mr-10"><b>Rights:</b> {{ current_object.dublin_core.rights.value }}</p>
                </v-row>
                <v-row>
                    <p class="mr-10"><b>Source:</b> {{ current_object.dublin_core.source.value }}</p>

                    <p class="mr-10"><b>Relation:</b> {{ current_object.dublin_core.relation.value }}</p>
                </v-row>
                <v-row>
                    <p class="mr-10"><b>Description:</b></p>
                </v-row>
                <v-row>
                    <p>{{ current_object.dublin_core.description.value }}</p>
                </v-row>
            </v-container>
        </v-row>

        <v-row>
            <v-container class="mb-15">
                <v-row>
                    <h3>Tags:</h3>
                </v-row>
                <v-row>
                    <v-chip class="ma-2" large v-for="(tag, index) in current_object.tags" :key="index">{{ tag }}</v-chip>
                </v-row>
            </v-container>
        </v-row>
        <v-row class="mt-20 mb-5">
            <v-divider></v-divider>
        </v-row>
        <v-row>
            <v-btn color="primary" @click="downloadFile">
                Download file
            </v-btn>
        </v-row>


    </div>
</template>

<script>
export default {
    name: "ObjectDetails",
    props: {
        objectId: {
            type: String,
            default: "as86d541asda65asd4a1sd546q5d1sa"
        },
    },
    data() {
        return {
            isLoading: false,
            current_object: {
                dublin_core: {
                    contributor: { value: "", default: "Dominik Horvath", hint: "An entity responsible for making contributions to the resource" },
                    coverage: { value: "", default: "Machine learning research", hint: "The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant" },
                    creator: { value: "", default: "John Doe", hint: "An entity primarily responsible for making the resource" },
                    date: { value: "", default: "2022-02-05", hint: "A point or period of time associated with an event in the lifecycle of the resource" },
                    description: { value: "", default: "Dataset for training ML models focused on self driving cars. Contains only generated (fake) data.", hint: "An account of the resource" },
                    format: { value: "", default: "CSV", hint: "The file format, physical medium, or dimensions of the resource" },
                    identifier: { value: "", default: "5112697e6c3d7999ddf7979948135b1f94f6add479911795fb341d6ea545a28a", hint: "An unambiguous reference to the resource within a given context" },
                    language: { value: "", default: "en", hint: "A language of the resource" },
                    publisher: { value: "", default: "FIIT STU", hint: "An entity responsible for making the resource available" },
                    relation: { value: "", default: "cars.csv", hint: "A related resource" },
                    rights: { value: "", default: "GNU licence", hint: "Information about rights held in and over the resource" },
                    source: { value: "", default: "https://kaggle.com", hint: "A related resource from which the described resource is derived" },
                    subject: { value: "", default: "Generated data from self driving simulations", hint: "The topic of the resource" },
                    title: { value: "", default: "default_cars.csv", hint: "A name given to the resource" },
                    type: { value: "", default: "comma-separated values", hint: "The nature or genre of the resource" },
                },
                tags: []
            }
        }
    },

    methods: {
        async downloadFile() {
            const download_id = this.current_object.dublin_core.title.value + "@" + this.current_object.dublin_core.identifier.value
            const res = await this.$axios.get(`/read/download_url/${download_id}`).catch(function (error) {
                console.log(error.toJSON())
                return
            })
            fetch(res.data)
                .then(response => response.blob())
                .then(blob => {
                    const url = window.URL.createObjectURL(blob);
                    const a = document.createElement('a');
                    a.href = url;
                    a.download = this.current_object.dublin_core.title.value;
                    document.body.appendChild(a);
                    a.click();
                    a.remove();
                    window.URL.revokeObjectURL(url);
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        }
    },

    async mounted() {
        this.isLoading = true
        const res = await this.$axios.get(`/read/details/${this.$props.objectId}`).catch(function (error) {
            console.log(error.toJSON())
            return
        })
        if (res.status === 404) {
            alert("Object does not exist")
            return
        }
        let metadata = res.data
        for (const [key, value] of Object.entries(metadata)) {
            if (key.startsWith("dcm_")) {
                let formatted_key = key.replace("dcm_", "")
                this.current_object.dublin_core[formatted_key].value = value
            }
            if (key == "tags") {
                this.current_object.tags = value
            }
        }
        this.isLoading = false
    }

}
</script>