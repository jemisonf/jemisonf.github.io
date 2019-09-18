---
title: New Relic, Spinnaker Monitoring Integration
short_description: Adding New Relic as a first class metric service for Spinnaker
published: false

---
I developed this code while working as an intern on New Relic's Build and Deploy Tools team. Our team at the time was working on adopting Spinnaker as a continuous deployment platform for Kubernetes. As a rule, engineering teams at New Relic use New Relic for monitoring, and tools is not an exception. This posed a problem with Spinnaker, as New Relic is not a first class citizen of basically any metric-related function in Spinnaker.

Our initial solution was to implement the Spinnaker Prometheus integration, and scrape those metrics into New Relic. That worked, but required a lot of additional configuration work on our part. The ideal solution would be a direct integration between the two, which is what I took on.

Spinnaker reports metrics via an endpoint exposed on each Spinnaker [microservice](https://www.spinnaker.io/reference/architecture/). Those metrics are then scraped by the [Spinnaker Monitoring Daemon](https://github.com/spinnaker/spinnaker-monitoring), a python app that handles the logic of reporting to individual metrics services. In Kubernetes deploys, it runs as a sidecar in each microservice pod.

According to the monitoring daemon docs:

> The daemon is extensible so that it should be straightforward to add other systems as well. In fact, each of the supported systems was provided using the daemon’s extension mechanisms – there are not “native” systems.

Therefore, it should be easy, right? Well yes, but actually no. The structure of the project is relatively complex, and uses a lot of inheritance and dependency injection, which can be become difficult to track in a mostly-undocumented Python project. It's certainly true that *if* you are familiar with the code base, it's a fairly straightforward task.

The other complicated task was figuring out how to actually report the metrics to New Relic. The New Relic Python Agent is an obvious vehicle for that, but it's intended to be used in applications which themselves are instrumed for New Relic APM, not applications which act as middlemen for other services.

Fortunately, the company had been developing a set of telemetry SDKs designed for exactly this purpose. I was given early access to the [Python SDK](https://github.com/newrelic/newrelic-telemetry-sdk-python), which was then open-sourced as I was working on the project. That gave me a really straightforward interface for reporting metrics, much more so than any other service in the monitoring daemon.

The workflow in code is basically:

```python
# initialize the monitoring daemon
metric_client = MetricClient(insert_key, host=host) 
# ... snip ... 
# create metric objects
metric_list.append(
  CountMetric(name=metric_name, value=metric_data_value["v"], interval_ms=interval, tags=tags))
# ... snip ...
# send off batches of metrics
response = self.metric_client.send_batch(chunk)
response.raise_for_status()
```
[source](https://github.com/spinnaker/spinnaker-monitoring/blob/372dce8d0a11f5d8631090e14e341fca48378c16/spinnaker-monitoring-daemon/spinnaker-monitoring/newrelic_service.py)