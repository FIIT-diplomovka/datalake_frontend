<template>
    <v-container>
        <v-row>
            <v-col>
                <h2>Metadata for <b>{{ objectName }}</b></h2>
            </v-col>
            <v-col class="d-flex justify-end">
                <v-btn @click="submitForm()" color="success">Submit</v-btn>
            </v-col>
        </v-row>
        <v-row>
            <v-col></v-col>
        </v-row>

        <v-row >
            <v-col v-if="isLoading">
                <span>Extracting metadata, please wait...</span>
                <v-progress-linear indeterminate></v-progress-linear>
            </v-col>
            <v-col v-else>
                <span>Extraction complete.  <v-icon color="green" large>mdi-check</v-icon></span>
            </v-col>


            <v-col v-if="!isLoading">
                <v-row>
                    <v-select v-model="selected_method" persistent-hint hint="Which tool is used to analyze current file. Default is Droid (static)" label="Metadata extraction method" outlined :items="metadata_extraction_methods"></v-select>
                    <v-btn color="primary" @click="analyze()" class="ma-2">Analyze</v-btn>
                </v-row>
            </v-col>
        </v-row>

        <v-row>
            <v-col v-if="!isLoading">
                <v-alert v-if="form.is_malware === 1" type="error">This file was identified as malware</v-alert>
                <v-alert v-if="form.is_malware === 0" type="success">This file was identified as safe</v-alert>
                <v-alert outlined v-if="form.is_malware === 'unsupported'" type="warning">This file cannot be checked for malware presence as this file type is not supported for this type of check</v-alert>
            </v-col>
        </v-row>

        <v-row>
            <v-container ref="dcm_form">
                <v-col>
                    <!-- dublin core -->
                    <v-form :disabled=formDisabled>
                        <v-row>
                            <h3>Dublin Core</h3>
                        </v-row>
                        <v-row>
                            <v-text-field v-model="form.dublin_core.title.value" outlined label="Title"></v-text-field>
                            <v-spacer></v-spacer>
                            <v-text-field v-model="form.dublin_core.creator.value" outlined label="Creator">
                            </v-text-field>
                        </v-row>
                        <v-row>
                            <v-text-field v-model="form.dublin_core.publisher.value" outlined label="Publisher">
                            </v-text-field>
                            <v-spacer></v-spacer>
                            <v-text-field v-model="form.dublin_core.contributor.value" outlined label="Contributor">
                            </v-text-field>
                        </v-row>
                        <v-row>
                            <v-text-field v-model="form.dublin_core.coverage.value" outlined label="Coverage">
                            </v-text-field>
                            <v-spacer></v-spacer>
                            <v-text-field v-model="form.dublin_core.subject.value" outlined label="Subject">
                            </v-text-field>
                        </v-row>
                        <v-row>
                            <v-text-field v-model="form.dublin_core.date.value" outlined label="Date"></v-text-field>
                            <v-spacer></v-spacer>
                            <v-text-field v-model="form.dublin_core.language.value" outlined label="Language">
                            </v-text-field>
                        </v-row>
                        <v-row>
                            <v-text-field v-model="form.dublin_core.format.value" outlined label="Format">
                            </v-text-field>
                            <v-spacer></v-spacer>
                            <v-text-field v-model="form.dublin_core.type.value" outlined label="Type "></v-text-field>
                        </v-row>
                        <v-row>
                            <v-text-field v-model="form.dublin_core.identifier.value" outlined label="Identifier">
                            </v-text-field>
                            <v-spacer></v-spacer>
                            <v-text-field v-model="form.dublin_core.rights.value" outlined label="Rights">
                            </v-text-field>
                        </v-row>
                        <v-row>
                            <v-text-field v-model="form.dublin_core.source.value" outlined label="Source">
                            </v-text-field>
                            <v-spacer></v-spacer>
                            <v-text-field v-model="form.dublin_core.relation.value" outlined label="Relation">
                            </v-text-field>
                        </v-row>
                        <v-row>
                            <v-textarea v-model="form.dublin_core.description.value" outlined auto-grow
                                label="Description">
                            </v-textarea>
                        </v-row>
                    </v-form>
                    <!-- Tags -->
                    <v-form v-on:submit.prevent>
                        <v-row>
                            <h3>Tags</h3>
                        </v-row>
                        <v-row>
                            <v-col>
                                <v-text-field @keyup.enter="addTag()" v-model="tag" label="Start typing tags" outlined>
                                </v-text-field>
                            </v-col>
                            <v-col>
                                <v-btn @click="addTag()" class="ma-1" color="primary" dark>
                                    <v-icon dark>
                                        mdi-plus-circle
                                    </v-icon>
                                    Add
                                </v-btn>
                            </v-col>
                        </v-row>
                        <v-row>
                            <div>
                                <v-chip close @click:close="form.tags = form.tags.filter(item => item !== tag)" class="ma-2" large v-for="(tag, index) in form.tags" :key="index">{{ tag }}</v-chip>
                            </div>
                        </v-row>
                    </v-form>
                </v-col>
            </v-container>
        </v-row>
    </v-container>
</template>


<script>
export default {
    object: { bucket: "", name: "" },
    name: 'NewEntryForm',
    

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
        async analyze() {
            if (this.selected_method === "")
                return
            let payload = this.$options.object
            let extraction_method = this.selected_method

            if (extraction_method === "" || extraction_method === "droid (static)") {
                extraction_method = "droid"
                this.last_used_method = "droid (static)"
            } else if (extraction_method === "tika (static)"){
                extraction_method = "tika"
                this.last_used_method = "tika (dynamic)"
            } else if (extraction_method === "droid (static) + GPT-3") {
                console.log("droid + gpt3")
                extraction_method = "droid"
                this.use_gpt3 = 1
                this.last_used_method = "droid (static) + GPT-3"
            } else if (extraction_method === "tika (dynamic) + GPT-3") {
                console.log("tika + gpt3")
                extraction_method = "tika"
                this.use_gpt3 = 1
                this.last_used_method = "tika (dynamic) + GPT-3"
            }

            payload.method = extraction_method
            payload.use_gpt3 = this.use_gpt3
            let res = await this.$axios.post("/write/restart_analysis", payload).catch(function (error) {
                console.log(error.toJSON())
                alert("Error when trying to submit the data. Check console.")
                this.use_gpt3 = 0
                return
            })
            if (res.status !== 200) {
                console.error("Somwthing went wrong, server response was: ", res.status)
                this.use_gpt3 = 0
                return
            }
            this.getMetadata()
            this.use_gpt3 = 0

        },

        addTag() {
            if (this.tag === "") {
                return
            }
            this.tag = this.tag.replace(",", " ")
            if (!this.form.tags.includes(this.tag)) {
                this.form.tags.push(this.tag)
            }
            this.tag = ""
        },

        async submitForm() {
            let object_info = {
                object: this.$options.object,
                dcm: {},
                tags: [],
                is_malware: 0
            }
            for (const [key, value] of Object.entries(this.form.dublin_core)) {
                let dcm_key = `dcm_${key}`
                object_info["dcm"][dcm_key] = this.form.dublin_core[key].value
            }

            object_info["tags"] = this.form.tags
            object_info["malware"] = this.form.is_malware
            let res = await this.$axios.post("/write/submit_new", object_info).catch(function (error) {
                console.log(error.toJSON())
                alert("Error when trying to submit the data. Check console.")
                return
            })
            if (res.status === 201 || res.status === 200) {
                this.$router.push("/")
            }


        },

        

        async checkMalware() {
            while (true) {
                let res = await this.$axios.post("/read/check_malware", this.$options.object).catch(function (error) {
                    console.log(error.toJSON())
                    return
                })
                if (res.status === 200) {
                    console.log("MALWARE CHECK IS DONE")
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
        },

        // start checking if object is parsed
        async getMetadata() {
            this.formDisabled = true
            this.isLoading = true
            this.loadingVisibility = 'visible'
            let object_metadata
            let seconds_waited = 0
            while (true) {
                let res = await this.$axios.post("/read/check_stage", this.$options.object).catch(function (error) {
                    console.log(error.toJSON())
                    return
                })
                if (res.status === 200) {
                    object_metadata = res.data.metadata
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
            this.form.dublin_core.contributor.value = object_metadata.dcm_contributor
            this.form.dublin_core.coverage.value = object_metadata.dcm_coverage
            this.form.dublin_core.creator.value = object_metadata.dcm_creator
            this.form.dublin_core.date.value = object_metadata.dcm_date
            this.form.dublin_core.description.value = object_metadata.dcm_description
            this.form.dublin_core.format.value = object_metadata.dcm_format
            this.form.dublin_core.identifier.value = object_metadata.sha_256
            this.form.dublin_core.language.value = object_metadata.dcm_language
            this.form.dublin_core.publisher.value = object_metadata.dcm_publisher
            this.form.dublin_core.relation.value = object_metadata.dcm_relation
            this.form.dublin_core.rights.value = object_metadata.dcm_rights
            this.form.dublin_core.source.value = object_metadata.dcm_source
            this.form.dublin_core.subject.value = object_metadata.dcm_subject
            this.form.dublin_core.title.value = object_metadata.dcm_title
            this.form.dublin_core.type.value = object_metadata.dcm_type
            this.form.is_malware = object_metadata.malware

            this.formDisabled = false
            this.isLoading = false

        }
    },
    data() {
        return {
            isLoading: true,
            formDisabled: true,
            metadata_extraction_methods: ["tika (dynamic)", "droid (static)", "tika (dynamic) + GPT-3", "droid (static) + GPT-3"],
            selected_method: "",
            last_used_method: "",
            use_gpt3: 0,
            tag: "",
            form: {
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
                tags: [],
                is_malware: 0,
            }
        }
    },

    mounted() {
        this.$options.object.bucket = this.objectBucket
        this.$options.object.name = this.objectName
        this.getMetadata()
        // this.checkMalware()
        // press Lshift + ~ to autofill with default values
        window.addEventListener("keydown", e => {
            if (e.code === "Backquote" && e.shiftKey) {
                console.log("Fill DCM automatically")
                // fill dublin core
                for (const [key, value] of Object.entries(this.form.dublin_core)) {
                    if (this.form.dublin_core[key].value === "") {
                        this.form.dublin_core[key].value = this.form.dublin_core[key].default
                    }
                }
                // fill tags
                this.form.tags.push("cars", "machine learning", "training")
            }
        });
    },


}
</script>