export const state = () => ({
    bucket: "",
    objectName: "",
    stage: ""
  })
  
  export const mutations = {
    setBucket(state, bucket) {
      state.bucket = bucket
    },

    setObjectName(state, objectName) {
        state.objectName = objectName
    }
  }
  