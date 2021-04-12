import { config } from "./config";
import adapter from 'axios/lib/adapters/http';
import axios from "axios";

const testData = {
  dev: {
    odsCode: 'A91368',
    asid: '918999199177'
  },
  test: {
    odsCode: 'B86041',
    asid: '200000001161'
  }
};

describe('MHS Route connection', () => {
  it('should return expected asid from MHS Route', async () => {
    const { odsCode, asid } = testData[config.nhsEnvironment];
    const serviceId = 'urn:nhs:names:services:gp2gp:RCMR_IN010000UK05';

    const mhsRouteUrl = `https://mhs-route-${config.nhsEnvironment}.mhs.patient-deductions.nhs.uk`;
    const baseUrl = mhsRouteUrl.replace(/\/$/, '');
    const url = `${baseUrl}/routing`;

    const res = await axios.get(url, {
        params: {
          'org-code': odsCode,
          'service-id': serviceId
        },
        adapter
      });

    expect(res.data.uniqueIdentifier[0]).toEqual(asid);
  })
})