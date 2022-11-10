<template>
    <v-container>
        <v-row class="pb-8">
            <h2>Dublin Core metadata for <b>{{ objectName }}</b></h2>
        </v-row>


        <v-row v-if="isLoading" class="pb-5">
            <span>Extracting metadata, please wait...</span>
            <v-progress-linear indeterminate></v-progress-linear>
        </v-row>
        <v-row v-else class="pb-5">
            <span>Extraction complete. <v-icon color="green" large>mdi-check</v-icon></span>
        </v-row>

        <v-row>
            <v-container ref="dcm_form">
                <v-form :disabled=formDisabled>
                    <v-row>
                        <v-text-field v-model="dublin_core.title.value" outlined label="Title"></v-text-field>
                        <v-spacer></v-spacer>
                        <v-text-field v-model="dublin_core.creator.value" outlined label="Creator"></v-text-field>
                    </v-row>
                    <v-row>
                        <v-text-field v-model="dublin_core.publisher.value" outlined label="Publisher"></v-text-field>
                        <v-spacer></v-spacer>
                        <v-text-field v-model="dublin_core.contributor.value" outlined label="Contributor">
                        </v-text-field>
                    </v-row>
                    <v-row>
                        <v-text-field v-model="dublin_core.coverage.value" outlined label="Coverage"></v-text-field>
                        <v-spacer></v-spacer>
                        <v-text-field v-model="dublin_core.subject.value" outlined label="Subject"></v-text-field>
                    </v-row>
                    <v-row>
                        <v-text-field v-model="dublin_core.date.value" outlined label="Date"></v-text-field>
                        <v-spacer></v-spacer>
                        <v-text-field v-model="dublin_core.language.value" outlined label="Language"></v-text-field>
                    </v-row>
                    <v-row>
                        <v-text-field v-model="dublin_core.format.value" outlined label="Format"></v-text-field>
                        <v-spacer></v-spacer>
                        <v-text-field v-model="dublin_core.type.value" outlined label="Type "></v-text-field>
                    </v-row>
                    <v-row>
                        <v-text-field v-model="dublin_core.identifier.value" outlined label="Identifier"></v-text-field>
                        <v-spacer></v-spacer>
                        <v-text-field v-model="dublin_core.rights.value" outlined label="Rights"></v-text-field>
                    </v-row>
                    <v-row>
                        <v-text-field v-model="dublin_core.source.value" outlined label="Source"></v-text-field>
                        <v-spacer></v-spacer>
                        <v-text-field v-model="dublin_core.relation.value" outlined label="Relation"></v-text-field>
                    </v-row>
                    <v-row>
                        <v-textarea v-model="dublin_core.description.value" outlined auto-grow label="Description">
                        </v-textarea>
                    </v-row>
                </v-form>
            </v-container>
        </v-row>
    </v-container>
</template>


<script>
export default {
    object: { bucket: "", name: "" },
    name: 'DublinCoreForm',
    props: {
        objectBucket: {
            type: String,
            default: "sample_bucket"
        },
        objectName: {
            type: String,
            default: "sample_object.png"
        }
    },
    methods: {
        // start checking if object is parsed
        async getMetadata() {
            this.formDisabled = true
            this.loadingVisibility = 'visible'
            let object_metadata
            let seconds_waited = 0
            while (true) {
                let res = await this.$axios.post("/check_stage", this.$options.object).catch(function (error) {
                    console.log(error.toJSON())
                    return
                })
                if (res.status === 200) {
                    object_metadata = res.data
                    break;
                }
                // TODO: handle this
                if (seconds_waited > 60) {
                    console.log("Something might be wrong...")
                }
                // 2 sec delay between each requests
                await new Promise(r => setTimeout(r, 2000));
                seconds_waited += 2
            }
            this.dublin_core.contributor.value = object_metadata.dcm_contributor
            this.dublin_core.coverage.value = object_metadata.dcm_coverage
            this.dublin_core.creator.value = object_metadata.dcm_creator
            this.dublin_core.date.value = object_metadata.dcm_date
            this.dublin_core.description.value = object_metadata.dcm_description
            this.dublin_core.format.value = object_metadata.dcm_format
            this.dublin_core.identifier.value = object_metadata.etag
            this.dublin_core.language.value = object_metadata.dcm_language
            this.dublin_core.publisher.value = object_metadata.dcm_publisher
            this.dublin_core.relation.value = object_metadata.dcm_relation
            this.dublin_core.rights.value = object_metadata.dcm_rights
            this.dublin_core.source.value = object_metadata.dcm_source
            this.dublin_core.subject.value = object_metadata.dcm_subject
            this.dublin_core.title.value = object_metadata.dcm_title
            this.dublin_core.type.value = object_metadata.dcm_type

            this.formDisabled = false
            this.isLoading = false
            this.loadingVisibility = 'hidden'

        }
    },
    data() {
        return {
            loadingVisibility: 'visible',
            isLoading: true,
            formDisabled: true,
            dublin_core: {
                contributor: { value: "", hint: "An entity responsible for making contributions to the resource" },
                coverage: { value: "", hint: "The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant" },
                creator: { value: "", hint: "An entity primarily responsible for making the resource" },
                date: { value: "", hint: "A point or period of time associated with an event in the lifecycle of the resource" },
                description: { value: "", hint: "An account of the resource" },
                format: { value: "", hint: "The file format, physical medium, or dimensions of the resource" },
                identifier: { value: "", hint: "An unambiguous reference to the resource within a given context" },
                language: { value: "", hint: "A language of the resource" },
                publisher: { value: "", hint: "An entity responsible for making the resource available" },
                relation: { value: "", hint: "A related resource" },
                rights: { value: "", hint: "Information about rights held in and over the resource" },
                source: { value: "", hint: "A related resource from which the described resource is derived" },
                subject: { value: "", hint: "The topic of the resource" },
                title: { value: "", hint: "A name given to the resource" },
                type: { value: "", hint: "The nature or genre of the resource" },
            }
        }
    },

    mounted() {
        this.loadingVisibility = "visible"
        this.$options.object.bucket = this.objectBucket
        this.$options.object.name = this.objectName
        this.getMetadata()

    },


}
</script>