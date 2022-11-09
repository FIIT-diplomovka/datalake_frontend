<template>
    <v-container>
        <v-row class="pb-8">
            <h2>Dublin Core metadata for <b>{{ objectName }}</b></h2>
        </v-row>
        <v-container ref="dcm_form">
            <v-form>
                <v-row>
                    <v-text-field outlined label="Title"></v-text-field>
                    <v-spacer></v-spacer>
                    <v-text-field outlined label="Creator"></v-text-field>
                </v-row>
                <v-row>
                    <v-text-field outlined label="Publisher"></v-text-field>
                    <v-spacer></v-spacer>
                    <v-text-field outlined label="Contributor"></v-text-field>
                </v-row>
                <v-row>
                    <v-text-field outlined label="Coverage"></v-text-field>
                    <v-spacer></v-spacer>
                    <v-text-field outlined label="Subject"></v-text-field>
                </v-row>
                <v-row>
                    <v-text-field outlined label="Date"></v-text-field>
                    <v-spacer></v-spacer>
                    <v-text-field outlined label="Language"></v-text-field>
                </v-row>
                <v-row>
                    <v-text-field outlined label="Format"></v-text-field>
                    <v-spacer></v-spacer>
                    <v-text-field outlined label="Type "></v-text-field>
                </v-row>
                <v-row>
                    <v-text-field outlined label="Identifier"></v-text-field>
                    <v-spacer></v-spacer>
                    <v-text-field outlined label="Rights"></v-text-field>
                </v-row>
                <v-row>
                    <v-text-field outlined label="Source"></v-text-field>
                    <v-spacer></v-spacer>
                    <v-text-field outlined label="Relation"></v-text-field>
                </v-row>
                <v-row>
                    <v-textarea outlined auto-grow label="Description"></v-textarea>
                </v-row>
            </v-form>
        </v-container>

    </v-container>
</template>

<script>
export default {
    name: 'DublinCoreForm',
    props: {
        objectBucket: String,
        objectName: String
    },
    methods: {
    },
    data() {
    },

}
</script>