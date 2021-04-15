import adapter from 'axios/lib/adapters/http';
import axios from "axios";
import dateFormat from 'dateformat';
import { v4 as uuid } from 'uuid';
import { config } from "./utils/config";
import { testData } from "./utils/test-data";
import { testPdsRetrievalMessage } from "./utils/pds-retrieval-message";

describe('MHS Outbound', () => {
  it('should successfully retrieve patient data from pds', async () => {
    const { repoAsid, nhsNumber, gpOdsCode } = testData[config.nhsEnvironment];
    const timestamp = dateFormat(Date.now(), 'yyyymmddHHMMss');
    const conversationId = uuid();
    const interactionId = 'QUPA_IN000008UK02';
    const pdsAsid = '928942012545';

    const message = testPdsRetrievalMessage(conversationId, timestamp, pdsAsid, repoAsid, nhsNumber)

    const mhsOutboundUrl = `https://mhs-outbound-${config.nhsEnvironment}.mhs.patient-deductions.nhs.uk`
    const body = { payload: message };
    const headers = {
      headers: {
        'Content-Type': 'application/json',
        'Interaction-ID': interactionId,
        'Sync-Async': false,
        'Correlation-Id': conversationId,
        'Ods-Code': 'YES',
        'from-asid': repoAsid,
      },
      adapter
    };

    const res = await axios.post(mhsOutboundUrl, body, headers)

    expect(res.status).toEqual(200);
    expect(res.data).toContain(gpOdsCode)
  });
});