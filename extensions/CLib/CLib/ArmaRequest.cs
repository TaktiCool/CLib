using System;

namespace CLib
{
    public class ArmaRequest
    {
        public int TaskId { get; private set; }
        public string ExtensionName { get; private set; }
        public string ActionName { get; private set; }
        public string Data { get; private set; }

        public static ArmaRequest Parse(string input)
        {
            int headerStart = input.IndexOf(ControlCharacter.SOH);
            int textStart = input.IndexOf(ControlCharacter.STX);
            int textEnd = input.IndexOf(ControlCharacter.ETX);

            string header = input.Substring(headerStart < 0 ? 0 : headerStart + 1, (textStart < 0 ? input.Length : textStart) - 1);
            string[] headerValues = header.Split(new [] { ControlCharacter.US }, 3);

            var request = new ArmaRequest();
            int taskId;
            if (!int.TryParse(headerValues[0], out taskId))
                throw new ArgumentException($"Invalid task id: {headerValues[0]}");
            request.TaskId = taskId;
            request.ExtensionName = headerValues[1].Trim();
            request.ActionName = headerValues[2].Trim();
            request.Data = textStart < 0 ? "" : input.Substring(textStart + 1, textEnd - textStart - 1);

            return request;
        }
    }
}