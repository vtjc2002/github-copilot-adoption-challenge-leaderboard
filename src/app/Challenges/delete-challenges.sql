-- CAUTION: Deletes ALL Challenge rows
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION;

SELECT COUNT(*) AS ChallengeCount FROM dbo.Challenges;
SELECT COUNT(*) AS ParticipantScoresReferencingChallenges
FROM dbo.ParticipantScores ps
WHERE EXISTS (SELECT 1 FROM dbo.Challenges c WHERE c.ChallengeId = ps.ChallengeId);

-- Delete any dependent ParticipantScores
DELETE ps
FROM dbo.ParticipantScores ps
INNER JOIN dbo.Challenges c ON c.ChallengeId = ps.ChallengeId;

-- Delete all Challenges
DELETE FROM dbo.Challenges;

-- Reseed identity
DECLARE @ChallengeCount INT = (SELECT COUNT(*) FROM dbo.Challenges);
IF @ChallengeCount = 0
BEGIN
    DBCC CHECKIDENT ('dbo.Challenges', RESEED, 0) WITH NO_INFOMSGS;    
END
ELSE
BEGIN
    DECLARE @MaxChallengeId INT = (SELECT MAX(ChallengeId) FROM dbo.Challenges);
    DBCC CHECKIDENT ('dbo.Challenges', RESEED, @MaxChallengeId) WITH NO_INFOMSGS;
END;

SELECT COUNT(*) AS ChallengeCount_After FROM dbo.Challenges;
SELECT COUNT(*) AS ParticipantScoresReferencingChallenges_After
FROM dbo.ParticipantScores ps
WHERE EXISTS (SELECT 1 FROM dbo.Challenges c WHERE c.ChallengeId = ps.ChallengeId);

COMMIT TRANSACTION;
GO