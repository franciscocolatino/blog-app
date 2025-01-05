import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { jobId: String } 
  static targets = ['status', 'progress', 'progressBar', 'errors', 'linkToPosts'];

  apiUrl = `/jobs/${this.jobIdValue}`
  headers = { 'Accept': 'application/json' }

  connect() {
    this.startPolling();
  }

  startPolling() {
    this.pollingIntervalId = setInterval(() => {
      this.fetchJobStatus();
    }, 3000);
  }

  fetchJobStatus() {
    fetch(this.apiUrl, { headers: this.headers })
      .then(response => response.json())
      .then(data => {
        this.updateStatus(data.status);
        this.updateProgress(data.progress);
        this.updateErrors(data.job_errors);
        this.checkStopCondition(data);
      });
  }

  checkStopCondition(data) {
    if (data.status === 'done' || data.status === 'failure') {
      clearInterval(this.pollingIntervalId);
      
      if (data.status === 'done') { 
        const noticeMessage = decodeURIComponent("Post criado com sucesso!");

        const postIds = data.content.post_ids || [];
        const postIdsParam = postIds.length > 0 ? postIds.join(",") : "";

        const link = `/posts?postIdsActionNow=${postIdsParam}&notice=${noticeMessage}`;

        this.updateLinkToPosts(link);
      }
    }
  }

  updateStatus(status) {
    this.statusTarget.innerHTML = status;
  }

  updateProgress(progress) {
    this.progressTarget.innerHTML = progress;
    this.progressBarTarget.style.width = `${progress}%`;
  } 

  updateErrors(errors) {
    this.errorsTarget.innerHTML = errors?.join(', ') || 'Nenhum.';
  }
  updateLinkToPosts(link) {
    this.linkToPostsTarget.href = link;
    this.linkToPostsTarget.setAttribute('class', 'btn btn-success');
  }
}
